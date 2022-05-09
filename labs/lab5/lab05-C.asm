.data

stringA: .asciiz "We're off to see the wizard,"
stringB: .asciiz "the wonderful wizard of OZ!"
stringC: .asciiz "I'll be back..."
stringD: .asciiz "Doh!"

# Given the string address loaded in $8,
# find the address of the null value that
# ends the string, and leave this in $10

.text
	la $8, stringA
	
loop_start:
	lb $9, 0($8)
	beq $9, $0, finish
	addi $8, $8, 1
	beq $0, $0, loop_start
	
finish:
	add $10, $0, $8
	
	# At this point, the address of the null that
	# terminates the string loaded in line 13
	# must be stored in $10
