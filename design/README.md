🧮 Calculadora Digital en Verilog

Universidad Nacional De Colombia - Electrónica Digital I

👨‍💻 Autores

Samuel Hernández - ...

Steven Sebastian Osorio Castro - 1022922007

Daniel Puentes - ...


Este proyecto implementa una calculadora digital basada en un SoC, desarrollada en Verilog y probada en FPGA. 
La calculadora ejecuta una operación seleccionada y finalmente transforma el resultado a decimal para su rápida lectura.

Las operaciones implementadas son:

✖️ Multiplicación binaria

➗ División binaria

√ Raíz cuadrada binaria

🔄 Conversión Binario → BCD (decimal)

Las cuatro operaciones fueron construidas siguiendo la metodología del curso:

- Diagrama de flujo del algoritmo

- Diagrama ASM (máquina de estados)

- Camino de datos

- Unidad de control

- Interconexión como periféricos en un SoC

- Simulación en GTKWave

- Implementación final en FPGA

📁 Estructura Abreviada del Proyecto

```Bash
/design
  \firmware
  \rtl
    \peripheral_implementation
      \BCD_perip
        \diagrams
        \simulation
        \test_bench
        Makefile
        Readme.,d
        peripheral_BCD.v
      \diagrams
      \divider_perip
      \mult_perip
      \raiz_perip
      \uart_perip
    \raw_implementation
    \system_on_chip
  README.md
/docs
.gitignore
LISCENSE
README.md
```
Los módulos principales pueden consultarse aquí:

🔗 [Periferico Multiplicador](rtl/peripheral_implementation/mult_perip/test_benches/peripheral_mult_TB.v)

🔗 [Periferico Divisor](rtl/peripheral_implementation/divider_perip/test_benches/peripheral_div_TB.v)

🔗 [Periferico Raiz Cuadrada](rtl/peripheral_implementation/raiz_perip/test_benches/peripheral_raiz_TB.v)

🔗 [Periferico BCD](rtl/peripheral_implementation/BCD_perip/test_benches/peripheral_BCD_TB.v)

🔗 [Periferico uart](rtl/peripheral_implementation/uart_perip/peripehral_uart.v)

🔗 [system on chip SOC](rtl/system_on_chip/SOC.v)

🧩 Arquitectura General

El sistema está basado en un procesador conectado a cuatro periféricos dedicados.
El Address Decoder asigna un rango de direcciones a cada uno:

| Periférico | Dirección base |
| ---------- | -------------- |
| UART       | `0x400000`     |
| Raíz       | `0x410000`     |
| Mult       | `0x420000`     |
| Div        | `0x430000`     |
| BIN→BCD    | `0x440000`     |

A continuación se muestra la arquitectura final del SoC:

<img width="981" height="1044" alt="structure" src="https://github.com/user-attachments/assets/ae8ba115-437f-4c17-b5ba-5e52e8ebaa5b" />

🧮 Periférico Raíz Cuadrada

📌 Direcciones asignadas

| Registro | Dirección   |
| -------- | ----------- |
| RR       | `0xXXXXX1`  |
| init     | `0xXXXXX10` |
| R        | `0xXXX100`  |
| Q        | `0xXX1000`  |
| done     | `0xX10000`  |


📌 Diagramas

<img width="1491" height="842" alt="raiz" src="https://github.com/user-attachments/assets/d6a4893a-ddfb-4a35-b869-e46d52146d98" />

<img width="1220" height="514" alt="diagrama_raiz" src="https://github.com/user-attachments/assets/e49955e7-5548-4584-bd24-3675601278fc" />



➗ Periférico División

Diagramas

<img width="1220" height="514" alt="diagrama_divider" src="https://github.com/user-attachments/assets/74a8145a-c958-473b-a676-06605a645dd8" />



✖️ Periférico Multiplicación

Diagramas

<img width="1220" height="514" alt="diagrama_mult" src="https://github.com/user-attachments/assets/57fb741d-6465-406d-961f-a9fa99610485" />



🔄 Conversión BIN → BCD

📌 Direcciones:

| Registro | Dirección  |
| -------- | ---------- |
| BIN      | `0xXXXX04` |
| init     | `0xXXXX08` |
| UND      | `0xXXXX0C` |
| DEC      | `0xXXXX10` |
| CEN      | `0xXXXX14` |
| DONE     | `0xXXXX18` |

Diagramas

<img width="1848" height="832" alt="bcd" src="https://github.com/user-attachments/assets/b201b3f1-e8d5-4c7f-ad97-d2d28a16153e" />


<img width="1260" height="594" alt="diagrama_BCD" src="https://github.com/user-attachments/assets/cf29261b-6b31-46ed-9950-717b4215094c" />



🧪 Simulación

Cada periférico fue comprobado mediante Makefile para compilar con iverilog

🛠️ Implementación en FPGA

Luego de la simulación, el sistema completo fue cargado en una FPGA

📚 Referencia del curso

El diseño sigue la metodología del texto Diseño de Sistemas Digitales — Carlos Iván Camargo
(Adjuntado por el profesor y usado como guía conceptual). Además, se utiliza como referencia el repositorio "digital_UN"
