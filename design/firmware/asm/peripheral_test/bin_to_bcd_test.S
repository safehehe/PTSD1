.section .text
.globl main
.globl bcd_hw

.main:
    la s0, test_cases
    li s1, 2
.test_loop:
    lw a0, 0(s0)  #Carga BIN en a0, parametro de bcd_hw
    lw s2, 4(s0)  #Carga CEN en s2
    lw s3, 8(s0)  #Carga DEC en s3
    lw s4, 12(s0) #Carga UND en s4

    call bcd_hw #a0:UND, a1:DEC, a2:CEN

    bne a0, s4, test_failed_error
    bne a1, s3, test_failed_error
    bne a2, s2, test_failed_error
    #Si pasa todas la verificaciones
    li a3, 0xF1
    j test_next_case
test_failed_error:
    li a3, 0 #Si alguna prueba falla se queda a3 = 0
test_next_case:
    addi s0, s0, 16
    addi s1, s1, -1
    bne s1, zero, test_loop
inf_loop:
    j inf_loop

.section .data
.align 2
test_cases:
    .word 511 #Caso 1: BIN
    .word 5   #Caso 1: CEN
    .word 1   #Caso 1: DEC
    .word 1   #Caso 1: UND

    .word 256 #Caso 2: BIN
    .word 2   #Caso 2: CEN
    .word 5   #Caso 2: DEC
    .word 6   #Caso 2: UND
