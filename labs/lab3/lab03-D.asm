.text 
	# $8 : initial value for which we look for trailing zeros
	# $9 : the counter to keeps track of # of trailing zeros (result)
	# $10 :  the result of the AND with the mask
	
	ori $8, $0, 0x00000000   	# same as "addi $8, $0, 0xc800"
	
	ori $9, $0, 0		# counter
loop:
	andi $10, $8, 1
	bne $10, $0, exit
	addi $9, $9, 1
	srl $8, $8, 1
	b loop
	
exit:
	nop			# answer is in $9
	
	
	#The fatal flaw in this program is that it cannot handle zero as a 32 bit value. Because zero has no has no leading ones, 
	#there are also no trailing zeros. Or as the assembler interprets it, there are infinitely many trailing zeros.  This results in
	#an infinite loop.  To fix this issue we could add a "beq" where the program branches immediately to "exit" if there is a zero
	#value stored in register $8.  Another solution is to add another "beq", where the program will branch to exit once the counter 
	#reaches 32, at which point we can be certaing there are no leading ones.