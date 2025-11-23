.equ UART_BASE, 0x400000  
.equ DPRAM_BASE, 0x450000  

#.equ IO_LEDS, 4
#.equ IO_UART_DAT, 8
#.equ IO_UART_CNTL, 16
.section .text

calculator:
#   li   gp,UART_BASE
#   li   gp, DPRAM_BASE
#   li   sp,0x10040
    li   sp,0x1000
    la   a0, format
	call putstring
    la a0, text_mult
    call putstring
    la a0, text_div
    call putstring
    la a0, text_sqrt
    call putstring

loopM:
    li a0, '\n\r'
    call putchar
    #Receive operator
    call getchar
    call putchar
    mv a3, a0
    #Receive ' ' character
    call getchar
    call putchar
	# Receive first two digits decimal number	
	call getchar    # 
	call putchar    # echo
	addi a0, a0, -0x30
	li   a1, 10
	call mult_hw       # D0*10	
	mv   a1, a0     # first digit first number
	call getchar    # 
	call putchar    # echo
	addi a0, a0, -0x30
	add  a2, a0, a1 # a2 = D0*10 + D1 second digit first number
	
    li t0, 'S'
    beq t0, a3, skip_second_number
	
	#Receive ' ' character
    call getchar
    call putchar
	# Receive second two digits decimal number	
	call getchar    # 
	call putchar    # echo
	addi a0, a0, -0x30
	li   a1, 10
	call mult_hw       # D0*10	
	mv   a1, a0     # first digit operand
    call getchar    # 
	call putchar    # echo
	addi a0, a0, -0x30
	add  a0, a0, a1 # a0 = D0*10 + D1#second digit
	mv   t0, a0
	
skip_second_number:
	la   a0, result
	call putstring
	mv   a1,t0
	mv   a0,a2

operation_selection:
	li t0, '*'
	beq t0,a3, F_mult
	li t0, '/'
	beq t0,a3, F_div
	li t0, 'S'
	beq t0,a3, F_sqrt

print_res:		
	call bcd_hw
	addi a0,a0,0x30
	call putchar
	mv a0, a1
	addi a0,a0,0x30
	call putchar
	mv a0, a2
	addi a0,a0,0x30
	call putchar
	j    loopM

putstring:
	addi sp,sp,-4 # save ra on the stack
	sw ra,0(sp)   # (need to do that for functions that call functions)
	mv t2,a0	
.L1:
	lbu a0,0(t2)
	beqz a0,.L2
	call putchar
	addi t2,t2,1	
	j .L1
.L2:    
	lw ra,0(sp)  # restore ra
	addi sp,sp,4 # restore sp
	ret	

F_mult:
	call mult_hw
	j print_res
F_div:
	call div_hw
	j print_res
F_sqrt:
	call sqrt_hw
	j print_res

.section .data
text_mult:
    .asciz "\n\r -* Number Number- \n\r"
text_div:
    .asciz "\n\r -/ Number Number- \n\r"   
text_sqrt:
    .asciz "\n\r -S Number- \n\r"
format:
	.asciz "\n\r - op n1 [n2] - \n\r"
result:
	.asciz "\n\rResult = "
