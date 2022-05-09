.data

seven_segment:
	.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x5f, 0x7c, 0x39, 0x5e, 0x79, 0x71
	
.text
	addi $s0, $zero, 16
	
	la $s1, 0xffff0010
	la $s2, 0xffff0011
	la $s3, seven_segment
	
	
loop:
	addi $s0, $s0, -1
	
	# Load pattern for the digit
	add $t0, $s0, $s3
	lb $t1, 0($t0)
	
	###############################################
	# Display the digit on both seven-segment units
	sb $t1, 0($s1)
	sb $t1, 0($s2)
	
	#############################
	# Sleep for 1000 milliseconds
	
	jal delay_1000_msec

	bne $s0, $zero, loop
	
finish:
	addi $v0, $zero, 10
	syscall



delay_1000_msec:
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	addi $a0, $zero, 1000
	addi $v0, $zero, 32
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
