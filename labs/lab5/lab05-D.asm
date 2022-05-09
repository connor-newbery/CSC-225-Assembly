.data

stringA: .asciiz "We're off to see the wizard,"
stringB: .asciiz "the wonderful wizard of OZ!"
stringC: .asciiz "I'll be back..."
stringD: .asciiz "Doh!"

string_space:
	.asciiz "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"


# Given the string address loaded in $8,
# find the length of the string and store
# that length is $10

.text

	la $a0, string_space  
	jal set_string
	beq $zero, $zero, finish
	
set_string:
	la $a1, stringD
	
loop_start:
	lb $t0, 0($a1)		#load the btye at the adress stored in $a1
	beq $t0, $zero, finish
	sb $t0, 0($a0)		#store the byte now held in the $t0, into the address held by $a0
	addi $a1, $a1, 1	#increment the adress in $a1 by 1
	addi $a0, $a0, 1	#increment the adress in $a0 by 1
	beq $zero, $zero, loop_start
	
return_from_set_string:
	jr $ra
	
finish:
	# Nothing more is needed
	
	# At this point length of the string
	# is stored in $9
