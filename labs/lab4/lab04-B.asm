.data

nums:
	.word 1, 3, 5, -11, 22, 33, -4, 5, 0

	
.text
	li $10, 0xdeadbeef
	
	la $11, nums
	lw $12, 16($11)
	
	