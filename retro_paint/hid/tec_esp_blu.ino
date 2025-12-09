#include <Keypad.h>
#include "BluetoothSerial.h"


// BLUETOOTH REAL
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run make menuconfig to enable it
#endif

// Crea el objeto Bluetooth Serial, el nombre aparecerá al buscar
BluetoothSerial SerialBT;
const char *DEVICE_NAME = "ESP32_Pintor_4x4";

// --- CONFIGURACIÓN TECLADO 4x4 ---
const byte ROWS = 4;
const byte COLS = 4;
char keys[ROWS][COLS] = {
  { '1', '^', '3', 'A' },
  { '<', '=', '>', 'B' },
  { '7', 'v', '9', 'C' }, 
  { '*', '0', '#', 'D' }
};
// Ajusta estos pines a tu hardware real
uint8_t colPins[COLS] = { 4, 0, 2, 15 };
uint8_t rowPins[ROWS] = { 18, 5, 17, 16 }; 

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

// --- ESTADOS Y VARIABLES ---
const int MAX_SCREEN = 63;
const int MAX_PAL_X = 3; 
const int MAX_PAL_Y = 3; 

bool modoPaleta = false;
int cursor_x = 0;
int cursor_y = 0;
int saved_x = 0;
int saved_y = 0;

//  COMANDOS BINARIOS (Acordados con FPGA)
const byte CMD_NOP       = 0;
const byte CMD_MOVE      = 1; 
const byte CMD_DRAW      = 2; 
const byte CMD_GET_COLOR = 3; 
const byte CMD_PAL_MODE  = 4; 

// FUNCION PARA ENVIAR PAQUETES BINARIOS
void enviarPaquete(byte cmd, byte x, byte y) {
  // Header: 11000rrr (Bits 7 y 6 en 1 para sincronización)
  byte header = 0xC0 | (cmd & 0x07); 
  
  // X e Y (6 bits de datos, Bits 7 y 6 en 0)
  byte data_x = x & 0x3F; 
  byte data_y = y & 0x3F;

  // Enviar a través de Bluetooth Serial
  SerialBT.write(header);
  SerialBT.write(data_x);
  SerialBT.write(data_y);

  // Debugging serial:
  Serial.printf("TX BLUETOOTH: CMD=%d, X=%d, Y=%d\n", cmd, x, y);
}


// SETUP

void setup() {
  Serial.begin(115200);
  
  // Iniciar el módulo Bluetooth
  SerialBT.begin(DEVICE_NAME); 
  Serial.printf("ESP32 Bluetooth iniciado. Busque el dispositivo: %s\n", DEVICE_NAME);
  Serial.println("Esperando conexión...");

  // Espera a que el módulo Bluetooth se conecte al HC-05 (o similar) de la FPGA

  // Enviar posición inicial
  enviarPaquete(CMD_MOVE, cursor_x, cursor_y);
}


// LOOP PRINCIPAL

void loop() {
  char key = keypad.getKey();
  if (!key) return;

  // --- 1. TECLA PARA ABRIR PALETA ('C') ---
  if (key == 'C' && !modoPaleta) {
    saved_x = cursor_x;
    saved_y = cursor_y;
    modoPaleta = true;
    cursor_x = 0; 
    cursor_y = 0;
    enviarPaquete(CMD_PAL_MODE, cursor_x, cursor_y); 
    return;
  }

  // --- 2. TECLA DE ACCIÓN (ENTER/=) ---
  if (key == '=') {
    if (!modoPaleta) {
      // MODO DIBUJO: PINTAR
      enviarPaquete(CMD_DRAW, cursor_x, cursor_y);
    } else {
      // MODO PALETA: SELECCIONAR COLOR Y SALIR
      enviarPaquete(CMD_GET_COLOR, cursor_x, cursor_y);
      // Restaurar estado
      modoPaleta = false;
      cursor_x = saved_x;
      cursor_y = saved_y;
      // Mover cursor visualmente de vuelta al dibujo
      enviarPaquete(CMD_MOVE, cursor_x, cursor_y);
    }
    return;
  }

  // --- 3. MOVIMIENTO (FLECHAS) ---
  int max_x = modoPaleta ? MAX_PAL_X : MAX_SCREEN;
  int max_y = modoPaleta ? MAX_PAL_Y : MAX_SCREEN;
  bool movio = false;

  if (key == '^') { if (cursor_y > 0) cursor_y--; movio = true; }
  if (key == 'v') { if (cursor_y < max_y) cursor_y++; movio = true; }
  if (key == '<') { if (cursor_x > 0) cursor_x--; movio = true; }
  if (key == '>') { if (cursor_x < max_x) cursor_x++; movio = true; }

  if (movio) {
    enviarPaquete(CMD_MOVE, cursor_x, cursor_y);
  }
}
