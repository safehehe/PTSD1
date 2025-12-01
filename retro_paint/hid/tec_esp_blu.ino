  #include <Keypad.h>

  // CONFIG TECLADO 4x4 //


  const byte ROWS = 4;
  const byte COLS = 4;

  char keys[ROWS][COLS] = {
    { '1', '^', '3', 'A' },
    { '<', '=', '>', 'B' },
    { '7', 'v', '9', 'C' },
    { '*', '0', '#', 'D' }
  };

  // pines correspondientes a las filas
  uint8_t colPins[COLS] = { 16, 4, 2, 15 };
  // pines correspondientes a las columnas
  uint8_t rowPins[ROWS] = { 19, 18, 5, 17 };
  // crea objeto con los prametros creados previamente
  Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);


  // BLUETOOTH (UART Serial2) //


  HardwareSerial BT(2);   // UART2

  // POSICIÓN DEL CURSOR      //


  int x = 0;
  int y = 0;

  // Límites de pantalla  ////
  const int MAX_X = 63;
  const int MAX_Y = 63;

  void enviar(String cmd) {
    BT.print(cmd);
    BT.print(",");
    BT.print(x);
    BT.print(",");
    BT.println(y);
  }

  void setup() {
    Serial.begin(115200);
    BT.begin(9600);  // velocidad típica HC-05

    Serial.println("ESP32 listo");
  }


  void loop() {

    char key = keypad.getKey();

    if (key) {

      switch(key) {

        case '^':    // arriba
          if (y > 0) y--;
          enviar("UP");
          break;

        case 'v':    // abajo
          if (y < MAX_Y) y++;
          enviar("DOWN");
          break;

        case '<':    // izquierda
          if (x > 0) x--;
          enviar("LEFT");
          break;

        case '>':    // derecha
          if (x < MAX_X) x++;
          enviar("RIGHT");
          break;

        case '=':    // enter
          enviar("ENTER");
          break;

        case 'C':    // color
          enviar("COLOR");
          break;

        default:
          enviar(String(key));  
          break;
      }

      Serial.print("Comando enviado: ");
      Serial.print(key);
      Serial.print("  Pos (");
      Serial.print(x);
      Serial.print(",");
      Serial.print(y);
      Serial.println(")");
    }
  }
//Pendiente: Si llama la paleta, recordar la posición actual y volver a ella al cerrar la paleta.