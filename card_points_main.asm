.data
card: .word 1234567

.text
.globl main
main:
lw $a0, card
jal card_points

move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "proj5.asm"
