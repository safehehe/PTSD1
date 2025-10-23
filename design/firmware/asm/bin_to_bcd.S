.equ BCD_BASE,   0x440000  
.equ BCD_BIN,   0x04
.equ BCD_INIT,   0x08
.equ BCD_UND,   0x0C
.equ BCD_DEC, 0x10
.equ BCD_CEN,   0x14
.equ BCD_DONE, 0x18

.section .text
.globl bcd_hw

  
bcd_hw:
  li   gp, BCD_BASE 
  sw   a0, BCD_BIN(gp)  
  li   a0, 1
  sw   a0, BCD_INIT(gp) 
  sw   zero, BCD_INIT(gp)  
.L0:
   li   t0, 1  
   lw   t1, BCD_DONE(gp)
   and  t1, t1, t0
   beqz t1, .L0  
   lw   a0, BCD_UND(gp)
   lw   a1, BCD_DEC(gp)
   lw   a2, BCD_CEN(gp)
  ret
