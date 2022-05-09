#Connor Newbery
#V00921506
# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_s 115
    .eqv SPACE    32
	.eqv BOX_COLOUR 0x0099ff33
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)

		#create the start box at 0,0
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, BOX_COLOUR
	jal draw_bitmap_box
	
check_for_event:
		#check for new keyboard input
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)			
	
		#if there's a value in KEYBOARD_EVENT, go deal with the value 
	la $s2, KEYBOARD_EVENT
	lb $s3, 0($s2)
	bne $s3, $zero, new_keystroke	
	

	beq $zero, $zero, check_for_event
	
	
	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10

.data
    .eqv BOX_COLOUR_BLACK 0x00000000
.text

	addi $v0, $zero, BOX_COLOUR_BLACK
	syscall


new_keystroke:
		#the following commands will branch to the procedure indicated by the middle label 
	beq $s3, LETTER_a, a_key
	beq $s3, LETTER_d, d_key
	beq $s3, LETTER_w, w_key
	beq $s3, LETTER_s, s_key
	beq $s3, SPACE, space
	
	beq $zero, $zero, back_to_check

a_key:
		#save the current box colour
	sw $a2, BOX_COLOUR_SAVE
	
		#colour in the original box
	addi $a2, $zero, BOX_COLOUR_BLACK
	jal draw_bitmap_box
	
		#reset the colour and create the new box one pixel to the left
	addi $a1, $a1, -1
	lw $a2, BOX_COLOUR_SAVE
	jal draw_bitmap_box
	
	beq $zero, $zero, back_to_check
d_key:	
		#save the current box colour
	sw $a2, BOX_COLOUR_SAVE
	
		#colour in the original box
	addi $a2, $zero, BOX_COLOUR_BLACK
	jal draw_bitmap_box
	
		#reset the colour and create the new box one pixel to the right
	addi $a1, $a1, 1
	lw $a2, BOX_COLOUR_SAVE
	jal draw_bitmap_box
	
	beq $zero, $zero, back_to_check
	
w_key:
		#save the current box colour
	sw $a2, BOX_COLOUR_SAVE
		#colour in the original box
	addi $a2, $zero, BOX_COLOUR_BLACK
	jal draw_bitmap_box
	
		#reset the colour and create the new box one pixel up
	addi $a0, $a0, -1
	lw $a2, BOX_COLOUR_SAVE
	jal draw_bitmap_box
	
	beq $zero, $zero, back_to_check
s_key:
		#save the current box colour
	sw $a2, BOX_COLOUR_SAVE
	
		#colour in the original box
	addi $a2, $zero, BOX_COLOUR_BLACK
	jal draw_bitmap_box
	
		#reset the colour and create the new box one pixel down
	addi $a0, $a0, 1
	lw $a2, BOX_COLOUR_SAVE
	jal draw_bitmap_box
	
	beq $zero, $zero, back_to_check
	
space:
		
	beq $a2, BOX_COLOUR, switch_to_my_colour	#if the box is currently the original colour, switch to my colour
	addi $a2, $zero, BOX_COLOUR			#else if the box is my colour, switch to the original colour
	jal draw_bitmap_box
	
	beq $zero, $zero, back_to_check

switch_to_my_colour:
	addi $a2, $zero, 0x00921506			#colour correspoding with my V-number
	
	jal draw_bitmap_box
	
	beq $zero, $zero, back_to_check

back_to_check:
		#reset KEYBOARD_EVENT and go back to the loop
	add $s3, $zero, $zero
	sw $s3, KEYBOARD_EVENT
	
	beq $zero, $zero, check_for_event
	
	
# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

draw_bitmap_box:
#
# You can copy-and-paste some of your code from part (c)
# to provide the procedure body.
#
		#Save all the values we need on the stack
	addi $sp, $sp, -8
	sw $ra, 0($sp)
		
		#temp register to cuont the columns drawn
	add $t0, $zero, $zero
	sw $t0, 4($sp)
	
		#save the box's row and column
	sw $a0, BOX_ROW
	sw $a1, BOX_COLUMN

next:
		#create the first column of 4 pixels
	jal set_pixel
	addi $a0, $a0, 1
	jal set_pixel
	addi $a0, $a0, 1
	jal set_pixel
	addi $a0, $a0, 1
	jal set_pixel
	
		#shift to the next column
	addi $a1, $a1, 1
		
		#reset the original row value, and increment the column counter
	lw $a0, BOX_ROW
	lw $t0, 4($sp)
	addi $t0, $t0, 1
	sw $t0, 4($sp)
		
		#stop drawing once we've drawn four columns
	bne $t0, 4, next
	
		#reset the column coordinates and go back
	lw $a1, BOX_COLUMN
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra


	.kdata

	.ktext 0x80000180
#
# You can copy-and-paste some of your code from part (a)
# to provide elements of the interrupt handler.
#
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
	
	beq $zero, $zero, __exit_exception	
	
	
__exit_exception:
	eret


.data

BOX_COLOUR_SAVE:		#a spot in memory to store the box's colour
	.word 0x0
# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


.eqv BOX_COLOUR_WHITE 0x00FFFFFF
	
