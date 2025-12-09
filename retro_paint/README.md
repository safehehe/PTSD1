# Retro Paint

## Universidad Nacional De Colombia - Electrónica Digital I

## Autores

*Samuel Felipe Hernández Herreño - 102740044*

*Steven Sebastian Osorio Castro - 1022922007*

*Daniel Santiango Puentes Villabona - 1052378730*

<img title="Retro Paint con IA" alt="Imagen de Retro Paint generada con IA" src="./diagrams/aigen.png" height="200">

## Dibuje y Visualice Pixel Art 64x64
Mediante el uso de un control y software dibuje en un lienzo de 64x64 pixeles con una profundidad de 8 bits por canal. Controle un teclado inalambrico y fluya a traves de la pantalla.

## Descripción General
Este proyecto implementa un sistema digital completo capaz de dibujar pixel art en una matriz 64×64 RGB utilizando un teclado 4×4 inalámbrico vía Bluetooth, un ESP32 y una FPGA como motor principal de procesamiento.

### El sistema permite:

Mover un cursor sobre un lienzo de 64×64 píxeles.

Cambiar el color actual (8 bits por canal — 24 bits RGB).

Pintar píxeles individuales.


Renderizar la matriz completa a 60 Hz.

La comunicación se realiza mediante un canal Bluetooth UART, desde el teclado → ESP32 → FPGA.
La FPGA decodifica comandos, controla el motor de dibujo y escribe los píxeles en cuadro de memoria.

## Objetivo General

Desarrollar un editor de Pixel Art 64×64 con control inalámbrico, capaz de dibujar y visualizar imágenes en una matriz LED RGB mediante una arquitectura digital implementada en FPGA.

## Requerimientos

### Hardware

- Matriz LED 64×64, 60 Hz, RGB 8 bits por canal.

- FPGA (cualquier con capacidad para framebuffer 64×64×24 bits).

- Un teclado 4×4 conectado por Bluetooth.

- Módulo Bluetooth → ESP32.

- Segundo módulo Bluetooth → FPGA (slave).

- Fuentes externas y reguladores.

### Software

- Firmware ESP32 (Bluetooth → UART → FPGA).

- Decodificador de comandos en Verilog.

- Motor de dibujo en Verilog (cursor + color + escritura de píxeles).

- Simulaciones Icarus Verilog + GTKWave.

- Renderizado en FPGA para enviar 64×64×24 bit al driver de la matriz.

- No portable

## Diagrama de Bloques General
<img title="Diagrama de bloques" src="./diagrams/bloques.png" height=400>

## Arquitectura del Sistema

El sistema está dividido en los siguientes subsistemas:

### 1. Teclado Inalámbrico (4×4)

- El teclado entrega un código hexadecimal (0–F) por cada tecla.

- Se conecta al primer módulo Bluetooth.

- El ESP32 recibe, interpreta y envía comandos stringizados a la FPGA:

```Bash
CURSOR_UP\n
CURSOR_DOWN\n
COLOR_NEXT\n
PAINT\n
```

### 2. Firmware ESP32 (Bluetooth → UART)

Funciones:

- Recibe eventos desde el módulo Bluetooth.

- Convierte las teclas a señales binarias.

- Los transmite a la FPGA mediante UART a 115200 baudios.


### 3. UART RX en FPGA

Módulo uart_rx.v:

- Detecta start bit.

- Ensambla bytes.

Envía:

- rx_valid

- rx_byte
  
- ry_byte


### 4. Line Buffer

Módulo line_buffer.v:

- Convierte el stream de bytes a una línea completa terminada en \n.

Entrega:

- line_ready

- line_str[]

### 5. Command Decoder

Módulo command_decoder.v

Se encarga de interpretar cadenas como:
```Bash
"UP"
"PAINT"
"COLOR_R"
```
Y convertirlas a señales:

- cmd_valid

- cmd_id (enumeración de comandos)

- cmd_data

### 6. Motor de Dibujo

Módulo draw_engine.v.

Controla:

- Cursor (x,y)

- Color actual

- Write enable

- Dirección de escritura

- Color que se va a escribir

Funciones soportadas:

| Acción                            | Descripción                   |
| --------------------------------- | ----------------------------- |
| `UP`, `DOWN`, `LEFT`, `RIGHT`     | Movimiento del cursor         |
| `PAINT`                           | Escribir pixel                |
| `CLEAR`                           | Poner negro                   |
| `COLOR_R` / `COLOR_G` / `COLOR_B` | Cambiar color actual          |
| `MODE`                            | Cambiar entre modos de dibujo |

Salida del motor:

- write_strobe

- write_x

- write_y

- write_color[23:0]

- cursor_x

- cursor_y

- current_color

## 7. Framebuffer / Pantalla

Memoria 64×64:

```Bash
64 x 64 x 24 bits = 98304 bits = 12.2 KB
```

Necesario:

- BRAM o SRAM

- Driver de matriz LED, 60 Hz.


## Máquina de Estados General

Todo el sistema sigue una cadena:
```Bash
UART → Buffer → Decoder → DrawEngine → Framebuffer → Render
```

FSM 1 — UART Receiver
FSM 2 — Line Buffer
FSM 3 — Command Decoder
FSM 4 — Motor de Dibujo
FSM 5 — Refresh 60 Hz

Control de pantalla:

<img width="1871" height="1553" alt="control_pantalla" src="./rtl/GPU_ASM/diagrams/gpu_bloques.png" />

Distribución:

<img width="1130" height="281" alt="distribucion" src="https://github.com/user-attachments/assets/501ce59c-3d13-4b92-8721-6a4c7de98222" />


Paint General:

<img width="2809" height="4769" alt="paint" src="https://github.com/user-attachments/assets/0a6ba81c-6fdb-4872-9c2d-e2cb2bbc1620" />


Lectura y envío de datos desde el teclado hacia la FPGA

<img width="871" height="1006" alt="read_teclado" src="https://github.com/user-attachments/assets/858aa325-cbf4-47eb-9943-ceef7761c321" />


## Estructura del Repositorio
```Bash
\retro_paint
  \data
    Paleta 256.gpl
  \diagrams
    aigen.png
    bloques.drawio
    control_pantalla.drawio
    distribucion.drawio
    paint.drawio
    read_teclado.drawio
  \hid
    Makefile
    bt_decoder.v
    read_teclado.png
    sim.out
    simulación.png
    tb_sistema.sv
    tec_esp_blu.ino
    top_fpga.v
    uart_rx.v
  \images
    paleta256.png
  \rtl
    \GPU_ASM
    \raw_implementation
      \building_blocks
        LSR.v
        MultipleRSR.v
        RSR.v
        acumulador.v
        acumulador_restando.v
        multiplexor2x1.v
        sumador.v
      \retro_paint_ASM
        check.v
        color_select.v
        paint.v
    \scripts
      \2_frames
      \4_frames
      \_pycache
  \scripts
  README.md

.gitignore
License
README.md

```

## Simulación

```
# Compilar

make


# Correr

make run


# Ver la forma de onda

make view

```

Señales visibles en la simulación:

- rx_byte

- rx_valid

- line_ready

- cmd_id

- cursor_x, cursor_y

- write_strobe

## Implementación en la FPGA

La FPGA recibe:

- write_x

- write_y

- write_color[23:0]

Y actualiza un framebuffer interno. Luego, un driver externo refresca la matriz RGB 64×64 a 60 Hz.

Pasos:
\retro_paint
  \data
    Paleta 256.gpl
  \diagrams
    aigen.png
    bloques.drawio
    control_pantalla.drawio
    distribucion.drawio
    paint.drawio
    read_teclado.drawio
  
1. Síntesis (yosys).

2. PnR (nextpnr).

3. Generar bitstream (ecppack).

4. Cargarlo (openFPGALoader).


## [Rubrica de Coevaluación y Heteroevaluación](./Coevaluaciones-Autoevaluaciones)


#### Referencia del curso
El diseño sigue la metodología del texto Diseño de Sistemas Digitales — Carlos Iván Camargo
(Adjuntado por el profesor y usado como guía conceptual). Además, se utiliza como referencia el repositorio "digital_UN" y los demás referenciados al interior del presente proyecto

