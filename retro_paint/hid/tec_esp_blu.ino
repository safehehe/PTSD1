#include <Keypad.h>

// ------------------------------------
// CONFIG TECLADO 4x4
// ------------------------------------

const byte ROWS = 4;
const byte COLS = 4;

char keys[ROWS][COLS] = {
  { '1', '^', '3', 'A' },
  { '<', '=', '>', 'B' },
  { '7', 'v', '9', 'C' },
  { '*', '0', '#', 'D' }
};

uint8_t colPins[COLS] = { 16, 4, 2, 15 };
uint8_t rowPins[ROWS] = { 19, 18, 5, 17 };

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

// ------------------------------------
// BLUETOOTH (UART Serial2)
// ------------------------------------

HardwareSerial BT(2);

// ------------------------------------
// POSICIÓN DEL CURSOR (DRAW MODE)
// ------------------------------------

int x = 0;
int y = 0;
const int MAX_X = 63;
const int MAX_Y = 63;

// ------------------------------------
// POSICIÓN DE PALETA
// ------------------------------------

bool enPaleta = false;
int px = 0;
int py = 0;
const int MAX_PX = 7;   // ejemplo paleta 8x8
const int MAX_PY = 7;

int saved_x = 0;
int saved_y = 0;

// ------------------------------------
// FUNCION PARA ENVIAR COMANDOS
// ------------------------------------

void enviar(String cmd, int a, int b) {
  BT.print(cmd);
  BT.print(",");
  BT.print(a);
  BT.print(",");
  BT.println(b);

  Serial.print("TX => ");
  Serial.print(cmd);
  Serial.print(" (");
  Serial.print(a);
  Serial.print(",");
  Serial.println(b);
}

// ------------------------------------
// SETUP
// ------------------------------------

void setup() {
  Serial.begin(115200);
  BT.begin(9600);

  Serial.println("ESP32 LISTA.");
}

// ------------------------------------
// LOOP PRINCIPAL
// ------------------------------------

void loop() {

  char key = keypad.getKey();
  if (!key) return;

  // -------------------------------
  // MODO PALETA
  // -------------------------------
  if (enPaleta) {

    switch(key) {

      case '^':
        if (py > 0) py--;
        enviar("PALETTE_MOVE", px, py);
        break;

      case 'v':
        if (py < MAX_PY) py++;
        enviar("PALETTE_MOVE", px, py);
        break;

      case '<':
        if (px > 0) px--;
        enviar("PALETTE_MOVE", px, py);
        break;

      case '>':
        if (px < MAX_PX) px++;
        enviar("PALETTE_MOVE", px, py);
        break;

      case '=': // ENTER → Seleccionar color
        enviar("PALETTE_SELECT", px, py);
        enPaleta = false;

        // restaurar posición guardada
        x = saved_x;
        y = saved_y;
        enviar("RETURN_TO_DRAW", x, y);
        break;

      default:
        break;
    }

    return;
  }

  // -------------------------------
  // MODO DIBUJO
  // -------------------------------
  switch(key) {

    case '^':
      if (y > 0) y--;
      enviar("UP", x, y);
      break;

    case 'v':
      if (y < MAX_Y) y++;
      enviar("DOWN", x, y);
      break;

    case '<':
      if (x > 0) x--;
      enviar("LEFT", x, y);
      break;

    case '>':
      if (x < MAX_X) x++;
      enviar("RIGHT", x, y);
      break;

    case '=':   // ENTER
      enviar("ENTER", x, y);
      break;

    case 'C':   // ABRIR PALETA
      enPaleta = true;

      // guardar posición actual
      saved_x = x;
      saved_y = y;

      // reiniciar posición de la paleta
      px = 0;
      py = 0;

      enviar("COLOR", px, py);
      break;

    default:
      enviar(String(key), x, y);
      break;
  }
}
