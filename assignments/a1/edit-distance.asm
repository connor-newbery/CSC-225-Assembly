# UVic CSC 230, Spring 2022
# Assignment #1, part B
# (Starter code copyright 2022 Mike Zastre)

# Determine the edit distance of values in registers $12 and $13
# Store this distance in register $20

#Connor Newbery, V00921506

.text

start:
	lw $12, testcase4_a  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	lw $13, testcase4_b  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# Your work here.
	
	xor $10, $12, $13
	
	li $9, 0		#loop counter
	li $20, 0 		#set register $20 to zero
	li $11, 32		#set register $11 to 32
loop:
	beq $9, $11, finish	#branch if the loop has iterated 32 times
	andi $14, $10, 1	#mask all values in register $10 except the rightmost bit
	bne $14, $0, increment	#branch to increment if the rightmost bit in 10 is not zero (one)

	srl $10, $10, 1		#shift the bits in register 10 to the right by 1
	addi $9, $9, 1		#increment the loop counter
	b loop	

increment:
	addi $20, $20, 1	#increment the counter
	srl $10, $10, 1		#shift the bits stored in register $10 to the right by 1
	addi $9, $9, 1		#increment the loop counter
	b loop
	
finish:
	nop
	

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

# The three lines of code below will eventually be
# explained in a bit more detail in CSC 230. In
# essence, MARS provides something similar to the
# system-call interface provided by many operating
# systems -- and one very important task an OS
# must do is to stop/terminate a running job. In
# essence, the code below causes MARS to stop your
# program in a safe way. (And believe you me --
# throughout the term there will be times when you
# write programs that do *not* end safely because
# of a bug (or three!).

exit:
	add $2, $0, 10
	syscall
		

.data

# Note: These test cases are not exhaustive. The teaching team
# will use other test cases when evaluating student submissions
# for this part of the assignment.

# testcase1: edit distance is 32
testcase1_a:
	.word	0x00000000
testcase1_b:
	.word   0xffffffff
	    

# testcase2: edit distance is 11
testcase2_a:
	.word	0xfacefade
testcase2_b:
	.word   0xdeadbeef
	
	
# testcase3: edit distance is 0
testcase3_a:
	.word	0xaaaa5555
testcase3_b:
	.word   0xaaaa5555
	
	
# testcase4: edit distance is 20
testcase4_a:
	.word	0xc6c6c6c6
testcase4_b:
	.word   0x51515151
