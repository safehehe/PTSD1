from PIL import Image

def compactar_color_8bit(r_8bit, g_8bit, b_8bit):
    """
    Compacta un color RGB de 24 bits (3x8 bits) a un solo byte de 8 bits 
    en el formato RRRGGGBB (R:3 bits, G:3 bits, B:2 bits).
    
    Rojo (R): 3 bits -> Toma los 3 bits más significativos de R (8 bits)
    Verde (G): 3 bits -> Toma los 3 bits más significativos de G (8 bits)
    Azul (B): 2 bits -> Toma los 2 bits más significativos de B (8 bits)
    
    El byte final es: [R2 R1 R0 G2 G1 G0 B1 B0]
    """
    # 1. Extraer los bits más significativos de 8 bits:
    # Para 3 bits (R y G), dividimos por 32 (2^(8-3)=32) para obtener el valor 0-7
    r_3bit = r_8bit // 32
    g_3bit = g_8bit // 32
    
    # Para 2 bits (B), dividimos por 64 (2^(8-2)=64) para obtener el valor 0-3
    b_2bit = b_8bit // 64
    
    # 2. Compactar los valores en un solo byte (8 bits):
    # R (3 bits) se desplaza 5 posiciones (3+2) -> [R R R 0 0 0 0 0]
    # G (3 bits) se desplaza 2 posiciones -> [0 0 0 G G G 0 0]
    # B (2 bits) se mantiene en las 2 posiciones menos significativas -> [0 0 0 0 0 0 B B]
    compacted_byte = (r_3bit << 5) | (g_3bit << 2) | b_2bit
    
    return compacted_byte

def procesar_imagen_a_hex(input_png_path, output_hex_path):
    """
    Lee una imagen PNG de 64x64, compacta los colores a RRRGGGBB y 
    escribe cada byte como una línea hexadecimal en el archivo de salida.
    """
    try:
        # Abrir la imagen
        img = Image.open(input_png_path)
        
        # Verificar dimensiones y convertir a RGB si es necesario (para asegurar 8 bits por canal)
        if img.size != (64, 64):
            print(f"Advertencia: El tamaño de la imagen es {img.size}, se esperaba (64, 64).")
        
        # Asegurarse de que la imagen está en modo RGB (8 bits por canal)
        img = img.convert("RGB")
        
        width, height = img.size
        
        # Obtener los datos de los píxeles
        pixel_data = img.getdata()
        
        # Lista para almacenar los bytes compactados
        compacted_bytes = []
        
        # Iterar sobre los píxeles y compactar el color
        for pixel in pixel_data:
            r, g, b = pixel
            compacted_value = compactar_color_8bit(r, g, b)
            compacted_bytes.append(compacted_value)
            
        # Verificar el número total de píxeles
        expected_pixels = 64 * 64
        if len(compacted_bytes) != expected_pixels:
            print(f"Error: Número de píxeles leído ({len(compacted_bytes)}) no coincide con el esperado ({expected_pixels}).")
            return

        # Escribir los bytes compactados en el archivo .hex
        with open(output_hex_path, 'w') as f:
            for byte_value in compacted_bytes:
                # Formatear el byte como una cadena hexadecimal de 2 caracteres, con salto de línea.
                # {:02X} -> rellena con cero a la izquierda, 2 caracteres, mayúsculas hexadecimales
                f.write(f"{byte_value:02X}\n")

        print(f"Proceso completado exitosamente.")
        print(f"Se leyeron {width * height} píxeles ({width}x{height}).")
        print(f"Se escribieron {len(compacted_bytes)} líneas en '{output_hex_path}'.")

    except FileNotFoundError:
        print(f"Error: No se encontró el archivo de imagen '{input_png_path}'.")
    except Exception as e:
        print(f"Ocurrió un error: {e}")

# --- Configuración ---
INPUT_FILE = "cosa-1.png.png"  # Reemplaza con el nombre de tu archivo PNG
OUTPUT_FILE = "cosa.hex"

# --- Ejecución ---
if __name__ == "__main__":
    procesar_imagen_a_hex(INPUT_FILE, OUTPUT_FILE)