.data
list: .word 0x48278291 0x92FEC713  # garbage

.text
.globl main
main:
la $a0, list
jal init_list


move $a1, $a0


lw $a0, 0($a1)


li $v0, 1
syscall

lw $a0, 4($a1)

li $v0, 1
syscall


li $v0, 10
syscall

.include "proj5.asm"
