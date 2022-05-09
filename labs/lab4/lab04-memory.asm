.data

bob:
	.word 212
	
connie:
	.word 40144
	
.text
	# Store the sum of integer
	# at 'bob' and integer at
	# 'connie' into register
	# $12 -- and without using
	# bob or connie directly
	# in a 'lw' instruction
	# (ie must use register and
	# an offset of zero).
	la $10, bob		#load the address of "bob" into register $10
	lw $12, 0($10)		#load the value stored at the adress of "bob" into register $12
	lw $11, 4($10)		#load the value stored at the adress 4 bits after "bob" (connie's address) into register $11
	add $12, $12, $11	#add the values in register $11 and $12 and store the result in $12
