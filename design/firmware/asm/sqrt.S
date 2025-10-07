.equ RAIZ_BASE,   0x410000  
.equ RAIZ_RR,   0x04
.equ RAIZ_INIT,   0x08
.equ RAIZ_R,   0x0C
.equ RAIZ_Q, 0x10
.equ RAIZ_DONE,   0x14

.section .text
.globl sqrt_hw

  
sqrt_hw:
  li   gp, RAIZ_BASE 
  sw   a0, RAIZ_RR(gp)  
  li   a0, 1
  sw   a0, RAIZ_INIT(gp) 
  sw   zero, RAIZ_INIT(gp)  
.L0:
   li   t0, 1  
   lw   t1, RAIZ_DONE(gp)
   and  t1, t1, t0
   beqz t1, .L0  
   lw   a0, RAIZ_R(gp)
   lw   a1, RAIZ_Q(gp)
  ret
