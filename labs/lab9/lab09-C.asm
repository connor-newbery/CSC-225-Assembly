
	.data
	.eqv  BITMAP_DISPLAY 0x10010000
	.eqv  PIXEL_WHITE    0x00ffffff
	
	.text
	
	la $s0, BITMAP_DISPLAY
	li $s1, PIXEL_WHITE
	
	# Draw a row of white pixels on the bitmap display tool
	# Use row 4. You will need to write a loop!
	addi $s0, $s0, 256
	sw $s1, 0($s0)		# This is not the correct value!
loop1:
	addi $s0, $s0, 4
	sw $s1, 0($s0)
	
	addi $t1, $t1, 1
	bne $t1, 15, loop1
	
	# Draw a column of white pixels on the bitmap display tool
	# Use column 3. You will need to write a loop!
	la $s0, BITMAP_DISPLAY
	addi $s0, $s0, 12
	sw $s1, 0($s0)		# This is not the correct value!
	add $t1, $zero, $zero
loop2: 
	addi $s0, $s0, 64
	sw $s1, 0($s0)
	
	addi $t1, $t1, 1
	bne $t1, 16, loop2

	addi $v0, $zero, 10
	syscall
