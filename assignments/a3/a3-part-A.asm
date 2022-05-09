#Connor Newbery
#V00921506
	.data
ARRAY_A:
	.word	21, 210, 49, 4
ARRAY_B:
	.word	21, -314159, 0x1000, 0x7fffffff, 3, 1, 4, 1, 5, 9, 2
ARRAY_Z:
	.space	28
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
		
	
	.text  
main:	
	la $a0, ARRAY_A
	addi $a1, $zero, 4
	jal dump_array
	
	la $a0, ARRAY_B
	addi $a1, $zero, 11
	jal dump_array
	
	la $a0, ARRAY_Z
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	addi $a1, $zero, 9
	jal dump_array
		
	addi $v0, $zero, 10
	syscall

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	
dump_array:
		#store the array's address on the stack
	addi $sp, $sp, -4
	sw $a0, 0($sp)

loop:
		#load the first word at the array's address, then store the next word's address
	lw $t0, ($sp)		
	lw $a0, 0($t0)		
	addi $t0, $t0, 4
	sw $t0, 0($sp)
		
		#output the first number in the array
	addi $v0, $zero, 1
	syscall
		
		#output the space
	la $a0, SPACE
	addi $v0, $zero, 4
	syscall
		
		#decrease the number of words left in the array until we've output them all
	sub $a1, $a1, 1
	bne $a1, $zero, loop
		
		#print a newline character
	la $a0, NEWLINE
	addi $v0, $zero, 4
	syscall
	
	addi $sp, $sp, 4
	jr $ra
	
	
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
