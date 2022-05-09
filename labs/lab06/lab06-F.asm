.data

seven_segment_rotate:
	.byte 0x01, 0x02, 0x04, 0x08, 0x10, 0x20
	
.text
	addi $a0, $zero, 0x2b
	jal count_up_with_display
	jal display_dashes
	
finish:
	addi $v0, $zero, 10
	syscall


# $a0: Maximum counter value

count_up_with_display:
	jr $ra


# $a0: hex digit to be displayed
# $a1: 0 == right display; 1 == left display

display_hex_digit:
	jr $ra
	
	
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
	
