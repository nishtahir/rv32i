.global _start

.text
_start:
    addi x2, x0, 1 
    slli x3, x2, 13
    addi x4, x3, 4 
    addi x5, x3, 8 
    addi x6, x0, 5
    addi x7, x0, 2
    sw x2, 0(x3)
    sw x2, 0(x4)
    sw x6, 0(x5)
    jal x1, 0
