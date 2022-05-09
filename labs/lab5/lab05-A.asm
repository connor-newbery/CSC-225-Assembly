.data

location1:	.space 4
location2:	.space 4

.text
	la $8, location1
	addi $9, $0, 0xcafef00d  # Same as decimal -889262067
	sw $9, 0($8)
	
	
	la $8, location2
	
	addi $9, $0, 0xca
	sb $9, 0($8)
	addi $8, $8, 1
	
	addi $9, $0, 0xfe
	sb $9, 0($8)
	addi $8, $8, 1
	
	addi $9, $0, 0xf0
	sb $9, 0($8)
	addi $8, $8, 1
	
	addi $9, $0, 0x0d
	sb $9, 0($8)
	
	
