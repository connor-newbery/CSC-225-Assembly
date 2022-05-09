.text 

label_A:
	addi $8, $0, 25
	beq $8, $9, label_C
	srl $8, $8, 5
	nop
	
label_B:
	addi $8, $8, -21
	andi $8, $8, 0x0abe
	beq $0, $0, label_A
	
label_C:
	nop
	beq $9, $8, label_A
	nop