	.data

S1:	.asciiz "In what year were you born? "
S2:	.asciiz "What year is it now? "
S3:	.asciiz "You will turn "
S4: 	.asciiz " years old this year.\n"
SPACE:	.asciiz " "
NL:	.asciiz "\n"
	
	.text
main:
	la $a0, S1	
	addi $v0, $zero, 4	#print first string
	syscall
	
	addi $v0, $zero, 5	#get the year and store in $v0
	syscall
	add $t1, $v0, $zero
	
	la $a0, S2
	addi $v0, $zero, 4	#print next string
	syscall
	
	addi $v0, $zero, 5	#get the current date and store in $v0
	syscall
	add $t0, $v0, $zero
	
	
	la $a0, S3		
	addi $v0, $zero, 4	#print the next string
	syscall
	

	sub $a0, $t0, $t1
	addi $v0, $zero, 1	#print the age
	syscall
	
	
	la $a0, S4
	addi $v0, $zero, 4
	syscall	
				
	addi $v0, $zero, 10
	syscall
