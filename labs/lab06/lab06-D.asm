.data

seven_segment:
	.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x5f, 0x7c, 0x39, 0x5e, 0x79, 0x71
	
.text
	addi $a0, $zero, 0xf
	addi $a1, $zero, 1
	jal display_hex_digit	
	
	
	addi $a0, $zero, 0x3
	addi $a1, $zero, 0
	jal display_hex_digit
	
finish:
	addi $v0, $zero, 10
	syscall


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
