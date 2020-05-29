.data
index: .word 0
num: .word 15
list:
.word 5  # list's size
.word node929 # address of list's head
node705:
.word 3
.word 0
node929:
.word 627
.word node371
node86:
.word 714
.word node18
node371:
.word 820
.word node86
node18:
.word 72
.word node705

.text
.globl main
main:
la $a0, list
lw $a1, index
lw $a2, num
jal set_value

move $a0, $v1
li $v0, 1
syscall

li $v0, 10
syscall

.include "proj5.asm"
