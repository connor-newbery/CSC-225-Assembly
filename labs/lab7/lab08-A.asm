	.data

S1:	.asciiz "abc def"
S2:	.asciiz "ghi jkl"
SPACE:	.asciiz " "
NL:	.asciiz "\n"
	
YEAR:	.word 2020
	
	
	.text
main:
	la $a0, S1
	addi $v0, $zero, 4
	syscall
	
	la $a0, SPACE
	addi $v0, $zero, 4
	syscall

	la $a0, S2
	addi $v0, $zero, 4
	syscall

	la $a0, SPACE
	addi $v0, $zero, 4
	syscall

	la $s0, YEAR
	lw $a0, 0($s0)
	addi $v0, $zero, 1
	syscall
	
	la $a0, NL
	addi $v0, $zero, 4
	syscall
			
	addi $v0, $zero, 10
	syscall
