# Compute the reverse of the input bit sequence that must be stored
# in register $8, and the reverse must be in register $15.

	.data
testcase_main:
	.word 0x00001c70

		
.text
start:
	lw $8, testcase_main 

	
# Purpose of registers:
# $8 : initial input value (plus subsequent modifications)
# $9 : count for number of bits examined
# $10 : mask for constructing result
# $11 : temporary for AND with mask & input

	add $9, $0, 32
	add $10, $0, 1
	sll $10, $10, 31
	add $15, $0, $0

loop_start:
	beq $9, $0, finish_work
	andi $11, $8, 0x1
	beq $11, $0, skip_bit_position	
	or   $15, $15, $10
	
skip_bit_position:
	srl $8, $8, 1
	srl $10, $10, 1
	addi $9, $9, -1
	beq $0, $0, loop_start
	
finish_work:
exit:
	add $2, $0, 10
	syscall
	
	

.data

testcase1:
	.word	0x00200020    # reverse is 0x04000400

testcase2:
	.word 	0x00300020    # reverse is 0x04000c00
	
testcase3:
	.word	0x1234fedc     # reverse is 0x3b7f2c48
	
testcaseEVAL:
	.word	0xdecafbad
