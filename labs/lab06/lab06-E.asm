.data

seven_segment:
	.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x5f, 0x7c, 0x39, 0x5e, 0x79, 0x71
	
.text
	addi $a0, $zero, 0x2b
	jal count_up_with_display
	jal display_dashes
	
finish:
	addi $v0, $zero, 10
	syscall


# $a0: Maximum counter value

count_up_with_display:
	addi $sp, $sp, -4
	sw $ra, ($sp)		#add return address to stack
	
	addi $sp, $sp, -4
	sb $a0, ($sp)		#add the number to count to to the stack
	
	addi $sp, $sp, -4
	addi $s1, $zero, 1
	sb $s1, ($sp)		#add a counter for the left digit to the stack
	
	add $s1, $zero, $zero
	addi $sp, $sp, -4
	sb $s1, ($sp)		#add a counter for the number of loop iterations to the stack
	
	addi $a0, $zero, 0
	addi, $a1, $zero, 0
	jal display_hex_digit
	
loop:
	addi $s0, $s0, 1
	lb $s1, ($sp)
	addi $s1, $s1, 1	#increment counter
	sb $s1, ($sp)		#store back into stack
	lb $s2, 8($sp)
	addi $s2 $s2, 1
	beq $s1, $s2, back	#compare the number of current loops iterations with the desried number
	beq $s0, 16, add_left
	
add_right:
	add $a0, $zero, $s0
	jal display_hex_digit	#incremen the right digit
	beq $zero, $zero, loop	
	
add_left:
	lb $a0, 4($sp)		#load the number for the left
	addi $a1, $zero, 1
	jal display_hex_digit	#increment the left digit
	
	addi $a0, $a0, 1
	sb $a0, 4($sp)		#store the next right digit back onto the stack
	
	add $a0, $zero, $zero
	addi $a1, $zero, 0
	jal display_hex_digit	#make the left digit a zero

	add $s0, $zero, $zero
	addi, $a1, $zero, 0
	
	beq $zero, $zero, loop
		
back:
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra


# $a0: hex digit to be displayed
# $a1: 0 == right display; 1 == left display

display_hex_digit:

	la $s0, 0xffff0011	#left
	la $s1, 0xffff0010	#right
	
	addi $sp, $sp, -8
	sw $s0, 0($sp)		#make room on stack
	sw $s1, 4($sp)
	
	add $s0, $zero, $a0		
	lb $s2, seven_segment($s0) 	#get hex representation from addr
	
	add $s1, $zero, $a1
	
	beq $s1, $zero, left
	beq $s1, 1, right

left:
	addi $sp, $sp, 4
	lw $s1, ($sp)
	addi $sp, $sp, 4
	sb $s2, ($s1)			#store the byte into the left side of DLS
	beq $zero, $zero, home
	
right:
	lw $s1, ($sp)
	addi $sp, $sp, 8
	sb $s2, ($s1)			#store the byte into the right side of DLS
	
home:
	jr $ra

	
#######################################	
delay_400_msec:
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	addi $a0, $zero, 400
	addi $v0, $zero, 32
	syscall
	
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	

display_dashes:
	jr $ra
	
