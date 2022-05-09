# UVic CSC 230, Spring 2022
#
# Howdy, world!

	.data
howdy_string:
	.asciiz	"\nHello! My name is Connor Newbery!\n\n"
howdy_number:
	.asciiz "V00921506\n"
	
	
	.text
main:
	li	$v0, 4
	la	$a0, howdy_string
	syscall
	
	li	$v0, 4
	la	$a0, howdy_number
	syscall
	
	li	$v0, 10
	syscall
