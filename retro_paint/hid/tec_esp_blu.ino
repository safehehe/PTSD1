#include <Keypad.h>
#include <HardwareSerial.h>

// --- CONFIGURACIÓN TECLADO 4x4 ---
const byte ROWS = 4;
const byte COLS = 4;
char keys[ROWS][COLS] = {
  { '1', '^', '3', 'A' },
  { '<', '=', '>', 'B' },
  { '7', 'v', '9', 'C' }, // 'v' es abajo, 'C' es paleta
  { '*', '0', '#', 'D' }
};
uint8_t colPins[COLS] = { 16, 4, 2, 15 };
uint8_t rowPins[ROWS] = { 19, 18, 5, 17 };
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

// --- BLUETOOTH ---
HardwareSerial BT(2); // TX2=17, RX2=16

// --- ESTADOS Y VARIABLES ---
// Límites de pantalla 64x64
const int MAX_SCREEN = 63;
// Límites de paleta (Asumiendo paleta lineal de 0 a 15, o matriz 4x4)
// Ajusta esto según el diseño visual de tu compañero. Pondré 4x4 (0-3).
const int MAX_PAL_X = 3; 
const int MAX_PAL_Y = 3;

bool modoPaleta = false;

// Posición actual (se usa tanto para dibujo como para cursor de paleta)
int cursor_x = 0;
int cursor_y = 0;

// Memoria para volver a la posición anterior
int saved_x = 0;
int saved_y = 0;

// --- COMANDOS BINARIOS (Acordados con FPGA) ---
const byte CMD_NOP       = 0;
const byte CMD_MOVE      = 1; // Solo mover cursor
const byte CMD_DRAW      = 2; // Pintar pixel
const byte CMD_GET_COLOR = 3; // Seleccionar color
const byte CMD_PAL_MODE  = 4; // Entrar modo paleta (opcional visual)

void setup() {
  Serial.begin(115200);
  BT.begin(9600); // Velocidad estándar HC-05
  Serial.println("SISTEMA INICIADO: MODO DIBUJO");
  // Enviar posición inicial
  enviarPaquete(CMD_MOVE, cursor_x, cursor_y);
}

void loop() {
  char key = keypad.getKey();
  if (!key) return;

  // --- MÁQUINA DE ESTADOS ---
  
  // 1. TECLA PARA ABRIR PALETA ('C')
  if (key == 'C' && !modoPaleta) {
    saved_x = cursor_x;
    saved_y = cursor_y;
    modoPaleta = true;
    cursor_x = 0; // Reset cursor para paleta
    cursor_y = 0;
    // Avisamos a FPGA que estamos en paleta y movemos
    enviarPaquete(CMD_PAL_MODE, cursor_x, cursor_y); 
    Serial.println("Modo Paleta Activado");
    return;
  }

  // 2. TECLA DE ACCIÓN (ENTER/=)
  if (key == '=') {
    if (!modoPaleta) {
      // Estamos en dibujo: PINTAR
      enviarPaquete(CMD_DRAW, cursor_x, cursor_y);
      Serial.println("Pintar Pixel");
    } else {
      // Estamos en paleta: SELECCIONAR COLOR Y SALIR
      enviarPaquete(CMD_GET_COLOR, cursor_x, cursor_y);
      // Restaurar estado
      modoPaleta = false;
      cursor_x = saved_x;
      cursor_y = saved_y;
      // Mover cursor visualmente de vuelta al dibujo
      enviarPaquete(CMD_MOVE, cursor_x, cursor_y);
      Serial.println("Color Seleccionado. Volviendo a Dibujo.");
    }
    return;
  }

  // 3. MOVIMIENTO
  int max_x = modoPaleta ? MAX_PAL_X : MAX_SCREEN;
  int max_y = modoPaleta ? MAX_PAL_Y : MAX_SCREEN;
  bool movio = false;

  if (key == '^') { if (cursor_y > 0) cursor_y--; movio = true; }
  if (key == 'v') { if (cursor_y < max_y) cursor_y++; movio = true; }
  if (key == '<') { if (cursor_x > 0) cursor_x--; movio = true; }
  if (key == '>') { if (cursor_x < max_x) cursor_x++; movio = true; }

  if (movio) {
    enviarPaquete(CMD_MOVE, cursor_x, cursor_y);
    Serial.printf("Mover a: %d, %d\n", cursor_x, cursor_y);
  }
}

// --- FUNCIÓN DE ENVÍO BINARIO ---
void enviarPaquete(byte cmd, byte x, byte y) {
  // Estructura del Header: 11000rrr (Bits 7 y 6 en 1)
  // cmd debe ser menor a 8 (3 bits)
  byte header = 0xC0 | (cmd & 0x07); 
  
  // X e Y deben ser menores a 64 (00xxxxxx)
  byte data_x = x & 0x3F; 
  byte data_y = y & 0x3F;

  BT.write(header);
  BT.write(data_x);
  BT.write(data_y);
}