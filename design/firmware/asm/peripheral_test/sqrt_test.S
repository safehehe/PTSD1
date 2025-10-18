# Archivo: sqrt_test.S
# Propósito: Probar el periférico de raíz cuadrada (sqrt_hw) en RISC-V.
# Convenciones:
#   - Entrada para sqrt_hw: a0 = número.
#   - Salida de sqrt_hw: a0 = raíz, a1 = resto.
#   - Salida del test: a2 = 1 (correcto), a2 = 0 (error).

.section .text
.globl main
.globl sqrt_hw # Se asume que este es el punto de entrada del periférico/función a probar.

main:
    # ----------------------------------------------------
    # Preparación de datos de prueba
    # ----------------------------------------------------
    # Definimos 3 casos de prueba: (Número, Raíz Esperada, Resto Esperado)
    # Caso 1: 9 -> Raíz=3, Resto=0
    # Caso 2: 15 -> Raíz=3, Resto=6
    # Caso 3: 27 -> Raíz=5, Resto=2
    
    # Registros utilizados:
    # s0: Puntero al array de casos de prueba
    # s1: Contador de pruebas (para el bucle)

    la s0, test_cases  # Carga la dirección base del array de casos de prueba
    li s1, 3           # Inicializa el contador de pruebas a 3
    
    # ----------------------------------------------------
    # Bucle Principal de Prueba
    # ----------------------------------------------------
test_loop:
    # ----------------------------------------------------
    # 1. Cargar el caso de prueba actual (3 palabras/elementos)
    # ----------------------------------------------------
    # s0 apunta a: [Número] [Raíz_Esp] [Resto_Esp]
    
    lw a0, 0(s0)       # Carga el Número de entrada en a0
    lw s2, 4(s0)       # Carga la Raíz Esperada en t0
    lw s3, 8(s0)       # Carga el Resto Esperado en t1
    
    # ----------------------------------------------------
    # 2. Llamar al periférico de raíz cuadrada
    # ----------------------------------------------------
    call sqrt_hw    # Llama a la función/periférico.
                       # Resultado en a0 (Raíz obtenida) y a1 (Resto obtenido)

    # ----------------------------------------------------
    # 3. Verificar los resultados
    # ----------------------------------------------------
    # Comprobar la Raíz (a0 == s2)
    bne a0, s2, test_failed_error # Si Raíz Obtenida != Raíz Esperada, ir a error
    
    # Comprobar el Resto (a1 == s3)
    bne a1, s3, test_failed_error # Si Resto Obtenido != Resto Esperado, ir a error
    
    # Si pasa ambas verificaciones
    li a2, 0xF1           # a2 = F1 (Prueba CORRECTA)
    j test_next_case   # Saltar a la preparación del siguiente caso
    
test_failed_error:
    li a2, 0           # a2 = 0 (Prueba INCORRECTA)

    # ----------------------------------------------------
    # 4. Preparación para el siguiente caso
    # ----------------------------------------------------
test_next_case:
    addi s0, s0, 12    # Avanza el puntero de casos de prueba (3 * 4 bytes = 12 bytes)
    addi s1, s1, -1    # Decrementa el contador de pruebas
    bne s1, zero, test_loop # Si s1 != 0, continuar con el bucle
    
    # ----------------------------------------------------
    # Bucle Infinito (Requerido para simulación 'main')
    # ----------------------------------------------------
inf_loop:
    j inf_loop         # Bucle infinito al finalizar todas las pruebas.
    
.section .data
.align 2
# Definición de los casos de prueba (Número, Raíz Esperada, Resto Esperado)
# Los datos están en formato de palabras de 4 bytes (.word)
test_cases:
    .word 9         # Caso 1: Número
    .word 3         # Caso 1: Raíz Esperada
    .word 0         # Caso 1: Resto Esperado
    
    .word 15        # Caso 2: Número
    .word 3         # Caso 2: Raíz Esperada
    .word 6         # Caso 2: Resto Esperado
    
    .word 27        # Caso 3: Número
    .word 5         # Caso 3: Raíz Esperada
    .word 2         # Caso 3: Resto Esperado
    
# FIN DEL PROGRAMA