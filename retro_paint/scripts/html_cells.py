import sys
import os
import itertools
from typing import List

# Definición de las dimensiones de la cuadrícula
ROWS = 16
COLS = 16
TOTAL_CELLS = ROWS * COLS

def generate_grid_html(colors: List[str]) -> str:
    """
    Genera el contenido HTML completo para la página web de la cuadrícula.

    Args:
        colors: Una lista de 4096 strings de color (ej: '#FF0000', 'blue', 'rgb(0,0,0)').

    Returns:
        El contenido HTML generado como un string.
    """
    
    # 1. Definición del CSS de la cuadrícula para ocupar toda la pantalla
    # No se usan frameworks, solo CSS puro.
    css_styles = f"""
        /* CSS para ocupar toda la pantalla y configuración de fuente */
        html, body {{
            margin: 0;
            padding: 0;
            height: 100vh;
            overflow: hidden; /* Evita barras de desplazamiento */
            font-family: Arial, sans-serif;
        }}

        /* Contenedor principal de la cuadrícula usando CSS Grid */
        #grid-container {{
            display: grid;
            width: 100vw;
            height: 100vh;
            /* Define 64 columnas con ancho igual (1 fracción) */
            grid-template-columns: repeat({COLS}, 1fr);
            /* Define 64 filas con altura igual (1 fracción) */
            grid-template-rows: repeat({ROWS}, 1fr);
        }}

        /* Estilo básico de cada celda */
        .cell {{
            box-sizing: border-box;
            border: none; /* Quitamos los bordes para un look limpio */
        }}
        .cell:hover {{
            box-sizing: border-box;
            border-style:solid;
            border-width: 2px;
            border-color : #FFFFFF;
        }}
    """

    # 2. Inicio de la estructura HTML
    html_content = f"""
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cuadrícula de Colores 64x64</title>
    <style>
{css_styles}
    </style>
</head>
<body>
    <div id="grid-container">
"""

    # 3. Generación de las celdas DIV con el color de fondo inline
    for color in colors:
        # Añade una celda, estableciendo el color de fondo directamente
        html_content += f'        <div class="cell" style="background-color: {color};"></div>\n'

    # 4. Cierre de la estructura HTML
    html_content += """
    </div>
    <!-- NOTA: Esta página ocupa el 100% del viewport (100vw x 100vh). -->
</body>
</html>
"""
    return html_content

def main(color_string_to_use = ""):
    """
    Función principal para manejar la entrada de parámetros y generar el archivo.
    """
    # Intenta obtener el parámetro de la línea de comandos
    
    # Si no se proporciona un argumento, genera un patrón de ejemplo (4096 colores)
    if not color_string_to_use:
        print("Uso: python grid_generator.py \"color1,color2,color3,...\"")
        print(f"El parámetro debe contener {TOTAL_CELLS} colores separados por comas. Generando un patrón de ejemplo...")

        # Patrón de ejemplo (alternando azul y rojo)
        example_colors = []
        color1 = '#3b82f6' # azul
        color2 = '#ef4444' # rojo
        for i in range(TOTAL_CELLS):
            example_colors.append(color1 if i % 64 < 32 else color2) # Un patrón de franjas

        color_string_to_use = ",".join(example_colors)
        
    # --- Procesamiento de la cadena de colores ---
    colors = [c.strip() for c in color_string_to_use.split(',') if c.strip()]
    
    if not colors:
        print("Error: La cadena de colores está vacía o es inválida.", file=sys.stderr)
        return

    # Si se proporcionaron menos de 4096 colores, los reciclamos (ciclo)
    if len(colors) < TOTAL_CELLS:
        print(f"Advertencia: Se recibieron {len(colors)} colores. Se ciclarán los colores para llenar las {TOTAL_CELLS} celdas.")
        # Usamos itertools.cycle para repetir la lista hasta alcanzar 4096
        colors = list(itertools.islice(itertools.cycle(colors), TOTAL_CELLS))
    elif len(colors) > TOTAL_CELLS:
        print(f"Advertencia: Se recibieron {len(colors)} colores. Se usarán solo los primeros {TOTAL_CELLS}.")
        colors = colors[:TOTAL_CELLS]

    # --- Generación y guardado del archivo ---
    html_content = generate_grid_html(colors)
    output_filename = "grid_64x64.html"

    try:
        with open(output_filename, "w", encoding="utf-8") as f:
            f.write(html_content)
        
        print("-" * 50)
        print(f"Página web generada exitosamente en: {output_filename}")
        print("Ábrela con tu navegador para ver la cuadrícula.")
        print("-" * 50)

    except IOError as e:
        print(f"Error al escribir el archivo {output_filename}: {e}", file=sys.stderr)

def to_hex_color(rrr:str,ggg:str,bb:str):
    #print("RR:",rr)
    #print("GG:",gg)
    #print("BB:",bb)
    #print("SS:",ss)
    red = int(rrr,2)*32
    green = int(ggg,2)*32
    blue = int(bb,2)*64
    #print("red:",red)
    #print("green:",green)
    #print("blue:",blue)
    hex_red = format(int(red),'02X')
    hex_green = format(int(green),'02X')
    hex_blue = format(int(blue),'02X')
    color = hex_red + hex_green + hex_blue
    return color

def decimal_to_color(decimal):
    bin_ = f'{decimal:08b}'
    rrr = bin_[0]+bin_[1]+bin_[2]
    ggg = bin_[3]+bin_[4]+bin_[5]
    bb = bin_[6]+bin_[7]
    return rrr,ggg,bb
def decimal_to_byte(decimal):
    hex_by = f'{decimal:02x}'
    return hex_by

palette_path = "./palette.hex"

if (__name__ == "__main__") :
    bytes_colors = []
    colors = []
    number = []
    for row in range (16):
        tmp_row = []
        tmp_bytes = []
        for col in range(16):
            colors.append("#"+ to_hex_color(*decimal_to_color(col + row*16)))
            number.append(col + row*16)
            bytes_colors.append(decimal_to_byte(col + row*16))
    print(colors)
    print(number)
    main(",".join(colors))
    with open(palette_path,'w') as f:
        f.write("\n".join(bytes_colors))
    print("Generada paleta en hex en:",palette_path)