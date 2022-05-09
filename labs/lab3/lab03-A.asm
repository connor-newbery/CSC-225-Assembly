.text 
	addi $8, $0, 0x7c63
	sll $8, $8, 1
	sll $8, $8, 1
	sll $8, $8, 1
	# What is the bit pattern in $8? Why is it 0x3e318?
	
	
	add $9, $0, 31
	sll $9, $9, 1
	sll $9, $9, 1
	sll $9, $9, 1
	# What is the value now in $9? Is it 31 * 8?
	
	
	andi $10, $8, 0x1f
	andi $11, $9, 0x1f
	addi $12, $0, 0x1f
	andi $12, $12, 0x7c63
	# Do the values in $10 and $11 and $12 look like
	# the result of a "modulo 16" operation?
	
	
	#
	# What is 3121 * 37?
	#
	
	addi $13, $0, 3121
	add $14, $0, $0
	
	# 37 = 1 + 4 + 32
	
	add $14, $14, $13   # 3121 * 1
	
	sll $13, $13, 2
	add $14, $14, $13   # + 3121 * 4
	
	sll $13, $13, 3
	add $14, $14, $13   # + 3131 * 32
	
	
	
	
	
	
