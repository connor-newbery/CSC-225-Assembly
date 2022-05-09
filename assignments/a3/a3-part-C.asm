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
	
	.globl main
	.text	
main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_box
	
	addi $a0, $zero, 11
	addi $a1, $zero, 6
	addi $a2, $zero, 0x00ffff00
	jal draw_bitmap_box
	
	addi $a0, $zero, 8
	addi $a1, $zero, 8
	addi $a2, $zero, 0x0099ff33
	jal draw_bitmap_box
	
	addi $a0, $zero, 2
	addi $a1, $zero, 3
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box

	addi $v0, $zero, 10
	syscall
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box
draw_bitmap_box:
		#Save all the values we need on the stack
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	
		#the original row value
	sw $a0, 4($sp)
	
		#temp register used as a counter to track the columns
	add $t0, $zero, $zero
	sw $t0, 8($sp)

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
		
		#reset the original row value, and increment the counter
	lw $a0, 4($sp)
	lw $t0, 8($sp)
	addi $t0, $t0, 1
	sw $t0, 8($sp)
		
		#stop drawing once we've drawn four columns
	bne $t0, 4, next
	
		
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
