# Liam Westhall
# lwesthall
# 111403927

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part 1 done
init_list:
sw $zero ($a0)
sw $zero 4($a0)
jr $ra





# Part 2 done
append:
addi $sp, $sp, -16
sw $s0, 0($sp) # the address of the list
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)


move $s0, $a0 #put address of list  into s0 so we can allocate with sbrk


li $a0, 8
li $v0, 9   #sbrk command
syscall

move $s1, $v0 #address of the new node placed in $v0 where are placing the num

lw $s2, 0($s0) #size of list

addi $s2, $s2, 1
sw $s2, 0($s0) #store the new incremented size in the list

loop_to_find_null:
lw $s3, 4($s0)
beqz $s3, append_num #checks if the address to next node is zero
move $s0, $s3 #put the address of the loading node into s0 to keep loop
j loop_to_find_null

append_num:
sw $s1, 4($s0)#storing new address at $s0
sw $a1, 0($s1)
sw $zero, 4($s1)
j append_exit


append_exit:
move $v0, $s2
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
addi $sp, $sp, 16
jr $ra


# Part 3
insert:
addi $sp, $sp, -28
sw $s0, 0($sp) # the address of the list
sw $s1, 4($sp)
sw $s2, 8($sp) #size
sw $s3, 12($sp) #address of node we are replacing
sw $s4, 16($sp) #counter for index
sw $s5, 20($sp) #index - 1
sw $ra, 24($sp)

move $s0, $a0 #put address of list  into s0 so we can allocate with sbrk

li $s4, 0

li $a0, 8
li $v0, 9   #sbrk command
syscall

move $s1, $v0

bltz $a2, invalid_insert

lw $s2, 0($s0) #size of list

beqz $s2, empty_insert


bgt $a2, $s2, invalid_insert

addi $s2, $s2, 1

addi $s5, $a2, -1

loop_to_index:
beq $s4, $s5, insert_node
lw $s3, 4($s0)
move $s0, $s3
addi $s4, $s4, 1
j loop_to_index


insert_node:
lw $s3, 4($s0)
sw $s1, 4($s0)
sw $a1, 0($s1)
sw $s3, 4($s1)
move $v0, $s2
j insert_exit


empty_insert:
jal append
addi $s2, $s2, 1
move $v0, $s2
j insert_exit

invalid_insert:
li $v0, -1

insert_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $ra, 24($sp)
addi $sp, $sp, 28
jr $ra


# Part 4
get_value:
addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

li $s2, 0 #counter for index

bltz $a1, invalid_get_value

move $s0, $a0 #move addr of list to $s0

lw $s1, 0($s0) #size of list

bge $a1, $s1, invalid_get_value #if index equal to size of greater invalid

get_value_loop:
lw $s3, 4($s0) #load address of node
lw $s4, 0($s3) #load number of the node
beq $s2, $a1, get_value_set
addi $s2, $s2, 1
move $s0, $s3
j get_value_loop

get_value_set:
li $v0, 0
move $v1, $s4
j get_value_exit

invalid_get_value:
li $v0, -1
li $v1, -1
j get_value_exit

get_value_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
addi $sp, $sp, 20
jr $ra

# Part 5
set_value:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

li $s2, 0 #counter for index

bltz $a1, invalid_set_value

move $s0, $a0 #move addr of list to $s0

lw $s1, 0($s0) #size of list

bge $a1, $s1, invalid_set_value #if index equal to size of greater invalid

set_value_loop:
lw $s3, 4($s0) #load address of node
lw $s4, 0($s3) #load number of the node
beq $s2, $a1, set_value_store
addi $s2, $s2, 1
move $s0, $s3
j set_value_loop

set_value_store:
sw $a2, 0($s3)
move $v1, $s4
li $v0, 0
j set_value_exit


invalid_set_value:
li $v0, -1
li $v1, -1
j set_value_exit



set_value_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
addi $sp, $sp, 20
jr $ra

# Part 6
index_of:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

li $s2, 0 #counter for index


move $s0, $a0 #move addr of list to $s0

lw $s1, 0($s0) #size of list

blez $s1, invalid_index_of

index_of_loop:
lw $s3, 4($s0)
beqz $s3, invalid_index_of #if next node is null then number isnt in lisr
lw $s4, 0($s3) #get the number
beq $s4, $a1, index_of_return #if number is equal to num then leave and return index count
addi $s2, $s2, 1 #increment index counter
move $s0, $s3 
j index_of_loop

index_of_return:
move $v0, $s2
j index_of_exit


invalid_index_of:
li $v0, -1
j index_of_exit


index_of_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
addi $sp, $sp, 20
jr $ra

# Part 7
remove:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

li $s2, 0 #counter for index


move $s0, $a0 #move addr of list to $s0

lw $s1, 0($s0) #size of list

blez $s1, invalid_remove

remove_loop:
lw $s3, 4($s0)
beqz $s3, invalid_remove #if next node is null then number isnt in lisr
lw $s4, 0($s3) #get the number
beq $s4, $a1, remove_num1 #if number is equal to num then leave and return index count
addi $s2, $s2, 1 #increment index counter
move $s0, $s3 
j remove_loop

remove_num1:
beqz $s2, remove_head
lw $s4, 4($s3) #address of node after the node we are removing
li $v0, 1
move $v1, $s2
li $s2, 0 #reset the counter

move $s0, $a0 #reset list address

addi $s1, $v1, -1

remove_num1_loop:
lw $s3, 4($s0)
addi $s2, $s2, 1
beq $s1, $s2, remove_num2
move $s0, $s3
j remove_num1_loop

remove_num2:
sw $s4, 4($s3)
j remove_exit

remove_head:
li $v0, 0
li $v1, 0
move $s0, $a0
lw $s4, 4($s3)
sw $s4, 4($s0)
j remove_exit

invalid_remove:
li $v0, -1
li $v1, -1
j remove_exit



remove_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
addi $sp, $sp, 20
jr $ra

# Part 8
create_deck:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $ra, 16($sp)

li $a0, 8 #sbrk
li $v0, 9 
syscall

move $a0, $v0

jal init_list

move $s3, $a0

move $s0, $a0
li $s1, 52

sw $s1, 0($s0)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s0)

move $s2, $v0

li $s3, 4403780
sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4469316

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4731460

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5452356

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4404036

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5452356

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4404036

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4469572

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4731716

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5452612

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4404292

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0


li $s3, 4469828

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4731972

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5452868

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4404548


sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4470084

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4732228

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5453124

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4404804

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4470340

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4732484 

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5453380

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4405060

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4470596

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4732740 

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5453636

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4405316

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4470852

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4732996

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5453892

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4405572

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4471108

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4733252

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5454148

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4409924

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4475460

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4737604

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5458500

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4411716

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4477252

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4739396

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5460292

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4410180

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4475716

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4737860

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5458756

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4407620

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4473156

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 4735300

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

li $s3, 5456196

sw $s3, 0($s2)

li $a0, 8 #sbrk
li $v0, 9 
syscall 

sw $v0, 4($s2)

move $s2, $v0

move $v0, $s3 #put the pointer to deck in v0
j create_deck_exit

create_deck_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra

# Part 9 done
draw_card:
addi $sp, $sp, -24
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $ra, 20($sp)

move $s0, $a0

lw $s1, 0($s0) #size

blez $s1, invalid_draw_card

lw $s2, 4($s0)

lw $s3, 0($s2)
lw $s4, 4($s2)

sw $s4, 4($s0)

li $v0, 0

move $v1, $s3
j draw_card_exit


invalid_draw_card:
li $v0, -1
li $v1, -1
j draw_card_exit


draw_card_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $ra, 20($sp)
addi $sp, $sp, 24
jr $ra

# Part 10
deal_cards:
addi $sp, $sp, -36
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)#size of the deck
sw $s5, 20($sp)
sw $s6, 24($sp) #current player array
sw $s7, 28($sp) #counter of cards dealt to each player
sw $ra, 32($sp)

move $s0, $a0 #deck
move $s1, $a1 #players
move $s2, $a2 #num_players
move $s3, $a3 #cards per player

move $t0, $a1 #extra pointer to beginning of players array

li $s5, 0 #counter of players
li $s7, 0

lw $s4, 0($s0) #size

blez $s4, invalid_deal_cards
blez $s3, invalid_deal_cards
blez $s2, invalid_deal_cards

li $t1, 0 #counter for the cards dealt entirely


deal_cards_loop:
beq $s5, $s2, go_back_to_first_player
move $a0, $s0
jal draw_card
addi $v1, $v1, 17 #make the card face up from being face down
move $a1, $v1 #put card into num for appened
lw $s6, 0($s1) 
move $a0, $s6
jal append
addi $s1, $s1, 4
addi $s5, $s5, 1
addi $t1, $t1, 1 #increment total cards dealt
beq $t0, $s2, deal_cards_exit1
j deal_cards_loop

#beq the number of playerd reset address of players to zero
go_back_to_first_player:
move $s1, $t0
addi $s7, $s7, 1 #increment cards dealt to each player
beq $s7, $s3, deal_cards_exit1 #stop dealing cards
li $s5, 0
j deal_cards_loop

#V0 has the card
deal_cards_exit1:
move $v0, $t1
j deal_cards_exit2

invalid_deal_cards:
li $v0, -1
j deal_cards_exit2

deal_cards_exit2:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra

# Part 11
card_points:
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)


move $s2, $a0


li $s0, 5460309
beq $a0, $s0, queen_of_spades
li $s0, 5460292
beq $a0, $s0, queen_of_spades
li $s1,  4731460
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4731716
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4731972
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4732228
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4732484
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1,  4732740
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4732996
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4733252
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4737604
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4739396
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4737860
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart
li $s1, 4735300
beq $a0, $s1, heart
addi $s1, $s1, 17
beq $a0, $s1, heart

li $s1, 4403780
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4404036
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4404292
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4404548
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4404804
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4405060
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4405316
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4405572
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4409924
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4411716
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4410180
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4407620
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4469316
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4469572
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4469828
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4470084
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4470340
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4470596
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4470852
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4471108
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4475460
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4477252
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4475716
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 4473156
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5452356
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5452612
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5452868
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5453124
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5453380
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5453636
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5453892
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5454148
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5458500
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5460292
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5458756
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
li $s1, 5456196
beq $a0, $s1, no_points
addi $s1, $s1, 17
beq $a0, $s1, no_points
j invalid_card_points
no_points:
li $v0, 0
j card_points_exit

invalid_card_points:
li $v0, -1
j card_points_exit

heart:
li $v0,1
j card_points_exit

queen_of_spades:
li $v0, 13
j card_points_exit

card_points_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
addi $sp, $sp, 12
jr $ra









# Part 12
simulate_game:
addi $sp, $sp, -36
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp) #player0
sw $s5, 20($sp) #player 1
sw $s6, 24($sp) #player 2
sw $s7, 28($sp) #player 3
sw $ra, 32($sp)

move $s0, $a0 #deck
move $s1, $a1 #players
move $s2, $a2 #num rounds


li $t2, 0
li $t3, 0
li $t4, 0
li $t5, 0     #my temp variable for this function
li $t6, 0
li $t7, 0
li $t8, 4
li $t9, 0









li $s3, 0 #counter for the rounds

#intialize the players first
lw $s4, 0($s1)
move $a0, $s4
jal init_list
addi $s1, $s1, 4 #increment addr for next player
lw $s4, 0($s1)
move $a0, $s4
addi $s1, $s1, 4 #increment addr for next player
jal init_list
lw $s4, 0($s1) 
move $a0, $s4
addi $s1, $s1, 4 #increment addr for next player
jal init_list
lw $s4, 0($s1)
move $a0, $s4
addi $s1, $s1, 4 #increment addr for next player
jal init_list


li $a2, 4 #theres four players to deal cards to
li $a3, 13 #we are dealing 13 cards to each player

jal deal_cards

#do index of U2C to find which player has a 2 of clubs

li $a1, 4403797 #the value of U2C 
move $a0, $s0
j ending_part_12

who_goes_first:
lw $a0, 0($s1)
jal index_of #find index of U2C in the list
bgez $v0, UtwoC_found
addi $t3, $t3, 1 #counter for what player has 2c
addi $s1, $s1, 4 #increment address of players list
j who_goes_first

UtwoC_found:
jal remove #remove 2C from the hand of the player who had it
mul $t3, $t7, $t3
sub $s1, $s1, $t3 #reset address of players to the starting address

ending_part_12:
jal draw_card
jal draw_card
jal draw_card
jal draw_card
jal draw_card
j simulate_game_exit




simulate_game_exit:
li $v0, 67109632
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra

#had a stomach bug so I could not finsih part 12 sorry


#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
