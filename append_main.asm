.data
num: .word 94
list:
.word 0  # list's size
.word 0  # address of list's head (null)


.text
.globl main
main:
la $a0, list
lw $a1, num
jal append







li $v0, 10
syscall

.include "proj5.asm"
