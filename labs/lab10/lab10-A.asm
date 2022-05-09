.data 

REGION_A: .space 32

REGION_B: .space 32

REGION_C: .space 32

REGION_D: .space 32

REGION_E: .space 32

SPACER_1: .space 128

REGION_M: .space 32


.text

start:	

    la $t1, REGION_A
    lb $t2, 0($t1)
    
    la $t1, REGION_B
    lb $t2, 0($t1)
    
    la $t1, REGION_A
    lb $t2, 1($t1)
    
    la $t1, REGION_C
    lb $t2, 0($t1)    
    
    la $t1, REGION_E
    lb $t2, 0($t1)
    lb $t2, 1($t1)
    
    la $t1, REGION_M
    lb $t2, 0($t1)


exit:
	add $2, $0, 10
	syscall
		
