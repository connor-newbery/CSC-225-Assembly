.data

stringA: .asciiz "We're off to see the wizard,"
stringB: .asciiz "the wonderful wizard of OZ!"
stringC: .asciiz "I'll be back..."
stringD: .asciiz "Doh!"

string_space:
	.space 100



.text
	la $a0, stringD
	jal string_len
	beq $0, $0, finish

string_len:
	add $v0, $zero, $zero
loop_start:
	lb $t0, 0($a0)
	beq $t0, $zero, return_from_string_len
	addi $a0, $a0, 1
	addi $v0, $v0, 1
	beq $zero, $zero, loop_start
return_from_string_len:
	jr $ra
	
finish:
	# Nothing more is needed
	
	# At this point length of the string
	# is stored in $v0 which is the same register as $2
	
	# Let's preserve this in $s0
	add $s0, $zero, $v0
	
	li $v0, 10
	syscall

