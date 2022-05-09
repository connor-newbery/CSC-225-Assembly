.data

stringA: .asciiz "abcdefg"
stringB: .asciiz "1234556"
stringC: .asciiz "abc"
stringD: .asciiz "1234567890"



.text
	# If both strings have the same length,
	# then 1 is stored in $12, 
	# otherwise 0 is stored in $12
	
	la $8, stringC   # string 1
	la $9, stringA   # string 2

loop_start:
	lb $10, 0($8)
	lb $11, 0($9)
	
	beq $10, $0, check_string_2_for_null
	beq $11, $0, same_length_fail   # If we get here, then string 2 is longer!
	addi $8, $8, 1
	addi $9, $9, 1
	beq $0, $0, loop_start
	
check_string_2_for_null:
	bne $11, $0, same_length_fail  # if string 2 is not null here, then string 1 is longer
	addi $12, $0, 1
	beq $0, $0, end_it_all
	
same_length_fail:
	add $12, $0, $0

end_it_all:
	# Nothing more is needed
	
	# At this point the value in $12 indicates
	# whether or not the strings have the same
	# length (0 == no, 1 == yes)

	li $2, 10
	syscall