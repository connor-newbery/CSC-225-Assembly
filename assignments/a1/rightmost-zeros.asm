# UVic CSC 230, Spring 2022
# Assignment #1, part A
# (Starter code copyright 2022 Mike Zastre)

# Determine the number of right-most zeros in register $12's value
# Store this number in register $15

#Connor Newbery, V00921506

.text

start:
	lw $12, testcase4  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	li $15, 0		#load 0 into register 15
	li $11, 32		#load 32 into register 32
loop:
	andi $13, $12, 1	#mask all values in register $12 except the rightmost bit
	bne $13, $0, finish	#branch if the rightmost bit is 0
	addi $15, $15, 1	#increment the counter
	beq $11, $15, finish	#branch if the counter reaches 32 which means the value in 12 is zero
	srl $12, $12, 1		#shift the bits in register 12 to the right by 1
	
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

testcase1:
	.word	0x00200020    # right-most zero bits is 5

testcase2:
	.word 	0xfacefade    # right-most zero bits is 1
	
testcase3:
	.word  0x12030400     # right-most zero bits is 10
	
testcase4:
	.word  0xc0000000    # right-most zero bits is 30
	
testcase5:
	.word  0x3000000a     # right-most zero bits is 1

