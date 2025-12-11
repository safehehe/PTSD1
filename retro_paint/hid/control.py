import bluetooth
import time
import os
from enum import IntEnum

# --- CONFIGURACIÓN BLUETOOTH Y MAC ---
# IMPORTANTE: 
# 1. Reemplaza '00:1A:7D:XX:XX:XX' con la DIRECCIÓN MAC del módulo Bluetooth receptor (HC-05/HC-06).
TARGET_MAC_ADDRESS = '05:4E:04:05:7A:A7' # <-- AJUSTAR ESTO


# --- DEFINICIONES DE COMANDOS (IGUAL QUE EN EL ESP32) ---
class CMD(IntEnum):
    """Comandos binarios acordados con la FPGA."""
    NOP = 0
    MOVE = 1
    DRAW = 2
    GET_COLOR = 3
    PAL_MODE = 4

# --- ESTADOS Y VARIABLES ---
MAX_SCREEN = 63
MAX_PAL_X = 15
MAX_PAL_Y = 15

modo_paleta = False
cursor_x = 0
cursor_y = 0
saved_x = 0
saved_y = 0

# --- MAPEO DE TECLAS (SIMULACIÓN DEL TECLADO FÍSICO) ---
TECLAS_MOVIMIENTO = {
    'w': '^',  # Arriba
    's': 'v',  # Abajo
    'a': '<',  # Izquierda
    'd': '>',  # Derecha
    'c': 'C',  # Modo Paleta
    'e': '=',  # Acción (Dibujar / Seleccionar Color)
}

# ----------------------------------------------------
# 1. FUNCIÓN DE ENLACE BINARIO
# ----------------------------------------------------
def enviar_paquete(sock, cmd: CMD, x: int, y: int):
    """
    Codifica el comando y las coordenadas en la trama binaria de 3 bytes
    y lo envía a través del socket Bluetooth.
    """
    # Header: 11000rrr (Bits 7 y 6 en 1 para sincronización)
    header = 0xC0 | (cmd.value & 0x07)
    
    # X e Y (6 bits de datos, Bits 7 y 6 en 0)
    data_x = x & 0x3F
    data_y = y & 0x3F

    # Creamos el paquete de 3 bytes
    paquete_bytes = bytes([header, data_x, data_y])
    
    sock.send(paquete_bytes) # Envío Inalámbrico Real

    print(f"\n[TX BLUETOOTH] CMD={cmd.name} ({cmd.value}), X={x}, Y={y}")
    print(f"   Bytes enviados: {list(paquete_bytes)} (Decimal)")
    print(f"   RAW Binario: {bin(header)[2:].zfill(8)} {bin(data_x)[2:].zfill(8)} {bin(data_y)[2:].zfill(8)}")

# ----------------------------------------------------
# 2. LÓGICA DEL PROGRAMA (LOOP PRINCIPAL)
# ----------------------------------------------------
def main():
    """Bucle principal que simula la lógica del ESP32."""
    global modo_paleta, cursor_x, cursor_y, saved_x, saved_y
    sock = None

    print("--- Simulador Python: Emisor Bluetooth Real ---")
    print(f"Intentando conectar al módulo receptor ({TARGET_MAC_ADDRESS})...")

    try:
        # 1. Encontrar el puerto SPP del dispositivo
        service_matches = bluetooth.find_service(address=TARGET_MAC_ADDRESS)

        if len(service_matches) == 0:
            print("ERROR: No se encontró el servicio SPP en el dispositivo objetivo.")
            print("Asegúrese de que el módulo esté encendido y emparejado (paired) con la PC.")
            return

        first_match = service_matches[0]
        port = first_match["port"]
        host = first_match["host"]

        # 2. Crear y conectar el socket Bluetooth
        sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
        sock.connect((host, port))
        
        print(f"Conexión establecida con {TARGET_MAC_ADDRESS} en el puerto {port}.")
        print("Presione 'q' para salir.")
        
    except Exception as e:
        print(f"ERROR al conectar por Bluetooth. Verifique PyBluez, drivers y la MAC.")
        print(f"Detalle: {e}")
        if sock: sock.close()
        return

    # Enviar posición inicial
    enviar_paquete(sock, CMD.MOVE, cursor_x, cursor_y)

    while True:
        try:
            # Limpiar la pantalla para una mejor visualización
            #os.system('cls' if os.name == 'nt' else 'clear')

            # Mostrar estado actual
            estado = "PALETA" if modo_paleta else "DIBUJO"
            print("========================================")
            print(f"MODO ACTUAL: {estado} | POS: ({cursor_x}, {cursor_y})")
            if modo_paleta:
                print(f"   (Volverá a: {saved_x}, {saved_y})")
            print("========================================")
            print("Comandos: w/a/s/d (Movimiento), e (Acción), c (Paleta), q (Salir)")
            
            # 3. Leer la entrada del usuario (simulando la pulsación de tecla)
            key_input = input("-> Ingrese tecla y presione Enter: ").lower()
            
            if key_input == 'q':
                print("Saliendo...")
                break
            
            if key_input not in TECLAS_MOVIMIENTO:
                continue

            key = TECLAS_MOVIMIENTO[key_input]

            # --- LÓGICA DE CONTROL ---
            
            # 1. TECLA PARA ABRIR PALETA ('C')
            if key == 'C' and not modo_paleta:
                saved_x = cursor_x
                saved_y = cursor_y
                modo_paleta = True
                cursor_x = 0
                cursor_y = 0
                enviar_paquete(sock, CMD.PAL_MODE, cursor_x, cursor_y)
                continue

            # 2. TECLA DE ACCIÓN (ENTER/=)
            if key == '=':
                if not modo_paleta:
                    # MODO DIBUJO: PINTAR
                    enviar_paquete(sock, CMD.DRAW, cursor_x, cursor_y)
                else:
                    # MODO PALETA: SELECCIONAR COLOR Y SALIR
                    enviar_paquete(sock, CMD.GET_COLOR, cursor_x, cursor_y)
                    # Restaurar estado
                    modo_paleta = False
                    cursor_x = saved_x
                    cursor_y = saved_y
                    # Mover cursor visualmente de vuelta al dibujo
                    enviar_paquete(sock, CMD.MOVE, cursor_x, cursor_y)
                continue

            # 3. MOVIMIENTO (FLECHAS)
            max_x = MAX_PAL_X if modo_paleta else MAX_SCREEN
            max_y = MAX_PAL_Y if modo_paleta else MAX_SCREEN
            movio = False

            if key == '^':
                if cursor_y > 0: cursor_y -= 1; movio = True
            elif key == 'v':
                if cursor_y < max_y: cursor_y += 1; movio = True
            elif key == '<':
                if cursor_x > 0: cursor_x -= 1; movio = True
            elif key == '>':
                if cursor_x < max_x: cursor_x += 1; movio = True

            if movio:
                enviar_paquete(sock, CMD.MOVE, cursor_x, cursor_y)

        except Exception as e:
            print(f"\nOcurrió un error inesperado: {e}")
            break

    if sock:
        sock.close()
        print("Conexión Bluetooth cerrada.")

if __name__ == '__main__':
    main()