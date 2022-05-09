# UVic CSC 230, Spring 2022
# Assignment #1, part C
# (Base code copyright 2022 Mike Zastre)

#Connor Newbery, V00921506

# Compute S % T, where S must be in $12, T must be in $13,
# and S % T must be in $19.

.text
start:
	lw $12, testcase1_S
	lw $13, testcase1_T

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
#Branch to the zero label if one of the values is zero
	beq $12, $0, zero
	beq $13, $0, zero

#If register $12 < $13 from the beginning, branch to store the value in $12
	slt $1, $12, $13
	bne $1, $0, store
	
#If both values are valid, subtract until reigster $12 < $13, then branch to store the value
loop:	
	sub $12, $12, $13	
	slt $1, $12, $13
	beq $0, $1, loop 
	bne $0, $1, store
	
#Store the remainder in register $19
store:
	add $19, $0, $12
	b finish
	
#Store -1 in register $19 if either register $12 or $13 began with a zero value 
zero:
	li $19, -1

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

# testcase1: 219 % 61 = 36
#
testcase1_S:
	.word	219
testcase1_T:
	.word 	61
	
# testcase2: 24156 % 77 = 55
#
testcase2_S:
	.word	24156
testcase2_T:
	.word 	77

# testcase3: 21 % 0 = -1
#
testcase3_S:
	.word	21
testcase3_T:
	.word 	0
	
# testcase4: 33 % 120 = 33
#
testcase4_S:
	.word	33
testcase4_T:
	.word 	120
	
testcaseEVALS:
	.word	391
testcaseEVALT:
	.word	0
