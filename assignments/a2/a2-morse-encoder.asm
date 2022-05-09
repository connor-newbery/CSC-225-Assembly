# a2-morse-encode.asm
#
# For UVic CSC 230, Spring 2022
#
# Original file copyright: Mike Zastre
#

.text


main:	

#Connor Newbery, V00921506

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


	## Test code that calls procedure for part A
	#jal save_our_souls
		

	## flash_one_symbol test for part B
	#addi $a0, $zero, 0x42   # dot dot dash dot
	#jal flash_one_symbol
	
	## flash_one_symbol test for part B
	#addi $a0, $zero, 0x37   # dash dash dash
	#jal flash_one_symbol
		
	## flash_one_symbol test for part B
	#addi $a0, $zero, 0x32  	# dot dash dot
	#jal flash_one_symbol
			
	## flash_one_symbol test for part B
	#addi $a0, $zero, 0x11   # dash
	#jal flash_one_symbol	
	
	# display_message test for part C
	#la $a0, test_buffer
	#jal display_message
	
	# char_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
	#addi $a0, $zero, 'P'
	#jal char_to_code

	
	# char_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
	#addi $a0, $zero, 'A'
	#jal char_to_code
	
	# char_to_code test for part D
	# the space' is properly encoded as 0xff
	#addi $a0, $zero, ' '
	#jal char_to_code
	
	# encode_text test for part E
	# The outcome of the procedure is here
	# immediately used by display_message
	la $a0, long_message
	la $a1, buffer01
	jal encode_text
	la $a0, buffer01
	jal display_message
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

	
	
###########
# PROCEDURE
save_our_souls:
	add $t0, $zero, $zero
	add $t5, $zero, $31	#Save the return address into a temporary reister for safe keeping
short:
	beq $t0, 9, return	#Branch to return once there has been 6 short blinks and 3 long blinks
	
	jal seven_segment_on		
	jal delay_short		#Sequence to generate a short blink	
	jal seven_segment_off		
	jal delay_long		
		
	addi $t0, $t0, 1	#Increment $t0 
	bne $t0, 3, short	#Loop through the short blink three times

	
long:
	jal seven_segment_on
	jal delay_long		
	jal seven_segment_off	#Sequence to generate a long blink
	jal delay_long
	addi $t0, $t0, 1	#Increment $t0
	bne $t0, 6, long	#Loop through the long blink three times
	beq $zero, $zero, short	#Branch back to the short loop
	
return:
	jr $t5			#Return to where we initially jumped to save_our_souls from


# PROCEDURE
flash_one_symbol:
	add $t5, $zero, $31	#Save the return address into a temporary reister for safe keeping
	
	add $t0, $zero, $zero 	#temp storage
	add $t4, $zero, $zero	#temp storage
	
	
	beq $a0, 0xff, spaces	#if the character is holds 0xff its a space, go do space sequence

	add $t0, $zero, $a0	#copy the value in $a0 into $t0
	
	
	srl $t0, $t0, 4		#holds the number of characters to be shown in the sequence
	sll $a0, $a0, 28	#holds the dot-dash sequence
	
	addi $t4, $t4, 4
	sub  $t4, $t4, $t0 	#holds the only number of leading zeros in $a0
	
	sllv $a0, $a0, $t4	#$a0 now holds the sequence of dots and dashes without any leading zeros
	
	lui $t6, 0x8000		#to compare the rightmost bit in a register
blink:
	beq $t0, $zero, done	#we've gone through all the characters, time to return
	
	and $t7, $a0, $t6	#checks if the value in the rightmost bit in $a0 is a 1 or 0
	
	beq $t7, $t6, dash	#the rightmost bit was a 1
	beq $t7, $zero, dot	#the rightmost bit was a 0

dash:
	jal seven_segment_on
	jal delay_long		
	jal seven_segment_off	#Sequence to generate a long blink
	jal delay_long
	
	sll $a0, $a0, 1		#shift $a0 to the left so a new bit can be checked
	addi $t0, $t0, -1	#decrease the number of bits left to be checked
	beq $zero, $zero, blink
	
dot:

	jal seven_segment_on		
	jal delay_short		#Sequence to generate a short blink	
	jal seven_segment_off		
	jal delay_long	
	
	sll $a0, $a0, 1		#shift $a0 to the left so a new bit can be checked
	addi $t0, $t0, -1	#decrease the number of bits left to be checked
	beq $zero, $zero, blink
	
spaces:
	jal delay_long
	jal delay_long		#sequence to generate a space
	jal delay_long
	
done:
	jr $t5			#return

###########
# PROCEDURE
display_message:
	addi $sp, $sp, -4	
	sw $ra, ($sp)		#keep return address safe
	addi $sp, $sp, -4
	sw $a0, ($sp)		#put the passed memory address into the stack
	
loop:
	lw $t1, ($sp)		#load the address stored in $sp
	lbu $a0, ($t1)		#load the byte found at the address
	beq $a0, $zero, jump	#jump if the byte is the terminator
	
	jal flash_one_symbol
	jal delay_long
	lw $t1, ($sp)		#retrieve the address from the stack
	la $t1, 1($t1)		#shift to the next byte
	sw $t1, ($sp)		#store the address back into the stack
	beq $zero, $zero, loop	

	
jump:
	addi $sp, $sp, 4	
	lw $ra, ($sp)		#retrieve original return address
	addi $sp, $sp, 4
	jr $ra
	
	
###########
# PROCEDURE
char_to_code:
	beq $a0, ' ', space
	addi $sp, $sp, -4
	sw $ra, ($sp)		#keep our return address safe in the stack
	la $t0, codes		#load the address of "codes"
	
	add $t5, $zero, $zero	#counter 
	
c_t_c_loop:	
	lb $t3, ($t0)			#load the first byte at "codes"
	beq $t3, $a0, store_letter	#if it's the letter we want, go to the next step 
	la $t0, 8($t0)			#if it's not the letter we want, go to the next byte in "codes"
	beq $zero, $zero, c_t_c_loop


store_letter:
	addi $sp, $sp, -4
	sw $t0, ($sp)			#store the address we found the letter at

count_characters:
	lb $t3, 1($t0)				#load the first byte
	beq $t3, $zero, store_number_of_chs	#if the byte is a 0, go to the next step
	addi $t5, $t5, 1			#increment the counter
	la $t0, 1($t0)				#go to the next byte in memory
	beq $zero, $zero, count_characters

store_number_of_chs:
	add $v0, $t5, $zero			#add the number of dots/dashes to the return register
	sll, $v0, $v0, 4			#move it into the second rightmost set of 4 bits

retrieve_ch_addr:
	lw $t0, ($sp)
	la $t0, 1($t0)				#retrieve the address at which we found the letter
	
	add $t5, $zero, $zero			#reset our counting register to create a register to hold character sequence

add_characters:
	lb $t3, ($t0)					#load the first dot-dash character
	beq $t3, $zero, add_chs_to_return_reg		#if its a 0 go to the next step
	beq $t3, '.', add_dot				#if its a dot go to the add_dot step
	beq $t3, '-', add_dash				#if its a dash go to the add_dash step
	la $t0, 1($t0)					#go to the next byte
	beq $zero, $zero, add_characters
	
		
add_dot:
	sll $t5, $t5, 1				#shift left to add a dot(a zero)
	la $t0, 1($t0)				#go to the next byte
	beq $zero, $zero, add_characters
	
add_dash:
	sll $t5, $t5, 1				#shift left
	addi $t5, $t5, 1			#add a dash(a one)
	la $t0, 1($t0)				#go to the next byte
	beq $zero, $zero, add_characters	
	
space:
	addi $v0, $zero, 0xff			#if the character was ' ', the return register must hold 0xff
	beq $zero, $zero, home
		
add_chs_to_return_reg:
	add $v0, $v0, $t5			#add the dot/dash sequence (as a 4 bit value) to the return register
	
	addi $sp, $sp, 8
	
home:
	jr $ra					#go home


###########
# PROCEDURE
encode_text:
	addi $sp, $sp, -4
	sw $ra, ($sp)		#store return addr
	addi $sp, $sp, -4
	sw $a0, ($sp)		#store the message addr

load_byte:
	lb $a0, ($a0)		#load the first byte found at the message's addr
	beq $a0, $zero, back
	jal char_to_code	#encode the letter

store_encoded_byte:
	sb $v0, ($a1)		#store the encoded value into buffer
	addi $a1, $a1, 1	#go to the next space in buffer

next_byte:
	lw $a0, ($sp)			#retrieve the message's address
	addi $a0, $a0, 1		#move the address over by one byte	
	sw $a0, ($sp)			#store the address back onto the stack
	beq $zero, $zero, load_byte	
		
	
	
back:
	addi $sp, $sp, 4
	lw $ra, ($sp)		#retrieve orginal return address
	addi $sp, $sp, 4
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x30 0x37 0x30 0x00    # This is SOS

long_message: .asciiz "laskd;fjasl;djf laksdjflaksjdflsadkjf l;asdjflaskfdlaskdf ;alskdflaskfdjalsdjf "
