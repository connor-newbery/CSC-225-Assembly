o.text
	addi $s0, $zero, 5
loop:
	beq $s0, $zero, finish


	################
	# Display dashes
	
	la $t0, 0xffff0011
	la $t1, 0xffff0010

	addi $t2, $zero, 0x40
	addi $t3, $zero, 0x40
	
	sb $t2, 0($t0)
	sb $t3, 0($t1)
	
	
	############################
	# Sleep for 400 milliseconds
	
	jal delay_400_msec


	################
	# Display blanks
	
	la $t0, 0xffff0011
	la $t1, 0xffff0010
	
	sb $zero, 0($t0)
	sb $zero, 0($t1)
	
	
	############################
	# Sleep for 400 milliseconds
	
	jal delay_400_msec
	

	################
	# Display digits
	
	la $t0, 0xffff0011
	la $t1, 0xffff0010

	addi $t2, $zero, 0x5b
	addi $t3, $zero, 0x06
	
	sb $t2, 0($t0)
	sb $t3, 0($t1)
	
	
	############################
	# Sleep for 400 milliseconds
		
	jal delay_400_msec
	
	
	################
	# Display blanks
	
	la $t0, 0xffff0011
	la $t1, 0xffff0010
	
	sb $zero, 0($t0)
	sb $zero, 0($t1)
	
	
	############################
	# Sleep for 400 milliseconds
		
	jal delay_400_msec
		
	
	addi $s0, $s0, -1
	beq $zero, $zero, loop
	
finish:
	addi $v0, $zero, 10
	syscall


delay_400_msec:
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	addi $a0, $zero, 400
	addi $v0, $zero, 32
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
