.text
	addi $8, $0, 4
	addi $9, $0, 11
	add $10, $0, $0   # for sum
	add $11, $0, $0   # for counter
	
	# Count-up loop (to 4)
loop:
	beq $8, $11, exit
	add $10, $10, $9
	addi $11, $11, 1
	b loop

exit:
	nop
	
