.text
	addi $a0, $zero, 10
	jal fibonacci
	
	add $a0, $zero, $v0
	addi $v0, $zero, 1
	syscall 
	
	addi, $v0, $zero, 10
	syscall
	

# fib(n) where n is in $a0
fibonacci:
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s0, 8($sp)
	# We'll keep 8($sp) for the "a" variable
	# and we'll keep 12($sp) for the "b" variable
	
	# We'll copy the parameter into $s0 as we
	# want to use this value between recursive calls.
	add $s0, $zero, $a0
	
	# Is the parameter < 2? If so, return 1
	addi $v0, $zero, 1
	addi $t0, $zero, 2
	slt $t1, $s0, $t0
	bne $t1, $zero, fibonacci_finish
	
	# If we arrive here, it is because we must 
	# now perform the recursive calls.
	
	# Make the recursive call for fib(n-1)
	addi $s0, $s0, -1
	add $a0, $zero, $s0
	jal fibonacci
	
	# Now store the return result into space we've
	# set aside on the stack (i.e., for "a")
	sw $v0, 4($sp)
	
	# Make the recursive call for fib(n-2)
	addi $s0, $s0, -1
	add $a0, $zero, $s0
	jal fibonacci
	
	# Now store the return result into space we've
	# set aside on the stack (i.e., for "b")
	sw $v0, 0($sp)
	
	# Now we can compute the sum of "a" and "b".
	# The value of "b" is *already* in $v0, but
	# the code below is written to mirror more
	# closely what is shown in the programming-language
	# version of fibonacci
	lw $v0, 4($sp)
	lw $s0, 0($sp)
	add $v0, $v0, $s0
	

fibonacci_finish:
	lw $s0, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra
