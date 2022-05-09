.text


main:
	

	
	ori $12, $15, 0xf
	addi $13, $zero, 100
	beq $13, $12, end
	
	add $5 $12, $13
end:
	addi $v0, $zero, 10 
	syscall

.data

red: .asciiz "Hello DirtBall"