#include <Keypad.h>
#include "BluetoothSerial.h"

// BLUETOOTH REAL
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run make menuconfig to enable it
#endif



BluetoothSerial SerialBT;
const char *DEVICE_NAME = "ESP32_Pintor_4x4";

// 🔴 REEMPLAZA ESTA DIRECCIÓN MAC por la de tu módulo receptor (HC-05/HC-06) 
// Ejemplo: "98:D3:31:F5:8A:27"
const char* TARGET_MAC_ADDRESS = "05:4E:04:05:7A:A7"; 

// Flag para saber si estamos conectados
bool isConnected = false; 

// --- CONFIGURACIÓN TECLADO 4x4 ---
const byte ROWS = 4;
// (El resto de la configuración del teclado y pines permanece igual)
const byte COLS = 4;
char keys[ROWS][COLS] = {
  { '1', '^', '3', 'A' },
  { '<', '=', '>', 'B' },
  { '7', 'v', '9', 'C' }, 
  { '*', '0', '#', 'D' }
};
// Pines - Asegúrate de que estos pines sean los seguros que definimos antes.
uint8_t colPins[COLS] = { 4, 13, 14, 27 }; // Pines seguros sugeridos
uint8_t rowPins[ROWS] = { 18, 5, 17, 16 }; 

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

// --- ESTADOS Y VARIABLES ---
// (Variables y comandos constantes permanecen iguales)
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
  if (!isConnected) {
    Serial.println("Error: No hay conexión Bluetooth activa.");
    return;
  }
  
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

// ------------------------------------
// FUNCIÓN DE CONEXIÓN ACTIVA
// ------------------------------------
void connectToTarget() {
  Serial.printf("Intentando conectar a MAC: %s\n", TARGET_MAC_ADDRESS);
  
  // La función connect() intenta establecer el enlace RFCOMM/SPP
  if (SerialBT.connect(TARGET_MAC_ADDRESS)) {
    Serial.println("Conexión Bluetooth exitosa!");
    isConnected = true;
    
    // Esperar un momento para asegurar que el canal esté listo
    delay(500); 
    
    // Enviar posición inicial (solo si la conexión es exitosa)
    enviarPaquete(CMD_MOVE, cursor_x, cursor_y);

  } else {
    Serial.println("Fallo al conectar. Reintentando en 5 segundos...");
    isConnected = false;
    delay(5000); // Esperar antes de reintentar
  }
}

// ------------------------------------
// SETUP
// ------------------------------------
void setup() {
  Serial.begin(115200);
  
  // 1. Inicializar Bluetooth en modo CLIENTE (Master)
  SerialBT.begin(DEVICE_NAME, true); // El 'true' establece el modo cliente
  
  Serial.printf("ESP32 iniciado como cliente. Buscando módulo: %s\n", TARGET_MAC_ADDRESS);
}

// ------------------------------------
// LOOP PRINCIPAL
// ------------------------------------
void loop() {
  // 1. Intentar conectar si no estamos conectados
  if (!isConnected) {
    connectToTarget();
    return; // Volver al inicio del loop para reintentar o esperar
  }
  
  // 2. Ejecutar lógica si la conexión está ACTIVA
  if (SerialBT.isClient()) {
      char key = keypad.getKey();
      if (!key) return;

      // --- LÓGICA DEL TECLADO (Igual que antes) ---
      
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
      
  } else {
      // La conexión falló o se perdió inesperadamente
      isConnected = false;
  }
}