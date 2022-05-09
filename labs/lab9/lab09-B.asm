
	.data
	.eqv  BITMAP_DISPLAY 0x10010000
	.eqv  PIXEL_WHITE    0x00ffffff
	
	.text
	
	la $s0, BITMAP_DISPLAY
	li $s1, PIXEL_WHITE
	sw $s1, 0($s0)
	addi $s0, $s0, 8
	sw $s1, 0($s0)
	
	la $s0, BITMAP_DISPLAY
	addi $s0, $s0, 128
	sw $s1, 0($s0)
	
	addi $v0, $zero, 10
	syscall