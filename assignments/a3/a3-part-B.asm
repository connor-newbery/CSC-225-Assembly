#Connor Newbery
#V00921506
	
	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	 	#The following four lines of code were taken from lab8 and not written by myself
	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)

check_for_event:
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)			#check for new keyboard input 
	
	la $s2, KEYBOARD_EVENT
	lb $s3, 0($s2)			#load the ascii value into $s3
	bne $s3, $zero, new_keystroke	#if there's a value in KEYBOARD_EVENT, go deal with the value 
	
	beq $s1, $zero, check_for_event

new_keystroke:
	la $t0, KEYBOARD_COUNTS
	
		#the following commands will branch to the procedure 
		#corresponding with the ascii value held in $s3
	beq $s3, 97, a_key
	beq $s3, 98, b_key
	beq $s3, 99, c_key
	beq $s3, 100, d_key
	beq $s3, 32, space
	beq $zero, $zero, check_for_event

a_key:			
		#increase the count found at the first word address in KEYBOARD_COUNTS
	lb $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)		
	
	beq $zero, $zero, back_to_check
	
b_key:
		#increase the count found at the second word address in KEYBOARD_COUNTS
	lb $t1, 4($t0)
	addi $t1, $t1, 1
	sw $t1, 4($t0)
	
	beq $zero, $zero, back_to_check
	
c_key:
		#increase the count found at the third word address in KEYBOARD_COUNTS
	lb $t1, 8($t0)
	addi $t1, $t1, 1
	sw $t1, 8($t0)
	
	beq $zero, $zero, back_to_check
	
d_key:
		#increase the count found at the fourth word address in KEYBOARD_COUNTS
	lb $t1, 12($t0)
	addi $t1, $t1, 1
	sw $t1, 12($t0)
	
	beq $zero, $zero, back_to_check
	

space:
		#output the value at the address of the first word held by the label KEYBOARD_COUNTS, which corresponds to count for 'a'
	la $t1, KEYBOARD_COUNTS
	lw $a0, 0($t1)
	addi $v0, $zero, 1
	syscall
	
		#output a space
	jal put_space_ch
	
		#output the count for 'b'
	lw $a0, 4($t0)
	addi $v0, $zero, 1
	syscall

		#output a space
	jal put_space_ch
	
		#output the count for 'c'
	lw $a0, 8($t0)
	addi $v0, $zero, 1
	syscall

		#output a space
	jal put_space_ch
	
		#output the count for 'd'
	lw $a0, 12($t0)
	addi $v0, $zero, 1
	syscall

		#output a newline character
	la $a0, NEWLINE
	addi $v0, $zero, 4
	syscall	
	
	beq $zero, $zero, back_to_check

put_space_ch:
		#output a single space
	la $a0, SPACE
	addi $v0, $zero, 4
	syscall		
	jr $ra
	
back_to_check:
		#reset KEYBOARD_EVENT and go back to the loop
	add $s3, $zero, $zero
	sw $s3, KEYBOARD_EVENT
	
	beq $zero, $zero, check_for_event
	
	
#kernel code
#vvvvvvvvvvvvvvvvvv
	.kdata
	

	.ktext 0x80000180
	

#Please note that much of the code below is taken from lab8, and therefore was not 
#written entirely by myself

__kernel_entry:
	mfc0 $k0, $13			# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c		# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2		# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt

__is_interrupt:
	andi $k1, $k0, 0x0100			# examine bit 8
	bne $k1, $zero, __is_keyboard_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	beq $zero, $zero, __exit_exception	# otherwise, we return exit kernel
	
__is_keyboard_interrupt:

	la $k0, 0xffff0004
	lw $k1, 0($k0)
	la $k0, KEYBOARD_EVENT
	sw $k1, 0($k0)	
	
	beq $zero, $zero, __exit_exception	# Kept here in case we add more handlers.
	
	
__exit_exception:
	eret
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

	
