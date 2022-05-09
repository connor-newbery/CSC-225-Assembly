.text
	addi $8, $0, 5       	# Initial value & counter
	addi $9, $0, 11
	add $10, $0, $0     	# For sum
	
	# Count-down loop (from 5)
loop:
	beqz $8, exit
	add $10, $10, $9
	addi $8, $8, -1
	b loop

exit:
	nop			# We'll do this differently in future labs
