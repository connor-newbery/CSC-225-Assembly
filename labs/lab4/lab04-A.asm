.text
start:
	nor $12, $21, $7
	srl $3, $4, 5
	addi $8, $0, 250
	beq $28, $5, asgard
	nop
	nop
asgard:
	nop
	beq $0, $0, start
	