# Skeleton file provided to students in UVic CSC 230, Spring 2022 
# Original file copyright Mike Zastre, 2022
#Connor Newbery, V00921506

.include "a4support.asm"

.data

.eqv	MAX_ARRAY_SIZE 1024

.align 2
ARRAY_1:	.space MAX_ARRAY_SIZE
ARRAY_2:	.space MAX_ARRAY_SIZE
ARRAY_3:	.space MAX_ARRAY_SIZE
ARRAY_4:	.space MAX_ARRAY_SIZE
ARRAY_5:	.space MAX_ARRAY_SIZE
ARRAY_6:	.space MAX_ARRAY_SIZE
ARRAY_7:	.space MAX_ARRAY_SIZE
ARRAY_8:	.space MAX_ARRAY_SIZE

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

FILENAME_1:	.asciiz "integers-40-2653.bin"
FILENAME_2:	.asciiz "integers-40-5897.bin"

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE



.globl main
.text 
main:

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $a0, FILENAME_1
	la $a1, ARRAY_1
	jal read_file_of_ints
	add $s0, $zero, $v0
	
	
	la $a0, FILENAME_2
	la $a1, ARRAY_2
	jal read_file_of_ints
	add $s0, $zero, $v0

	
	# WRITE YOUR SOLUTION TO THE PART E PROBLEM
	# HERE...
	
		#Accumulate array_1 into array 3
	la $a0, ARRAY_1
	la $a1, ARRAY_3		
	add $a2, $zero, $s0
	jal accumulate_max
	
		#Accumulate array_2 into array_4
	la $a0, ARRAY_2
	la $a1, ARRAY_4		
	add $a2, $zero, $s0
	jal accumulate_max
	
	
		#Reverse array_3 and store in array_5
	la $a0, ARRAY_3
	la $a1, ARRAY_5
	add $a2, $zero, $s0
	jal reverse_array
		

		#pairwise max with array 4 and 5, and store in array 6
	la $a0, ARRAY_4
	la $a1, ARRAY_5
	la $a2, ARRAY_6
	add $a3, $zero, $s0
	jal pairwise_max
	
		#accumulate the sum of array 6 and store in array 7
	la $a0, ARRAY_6
	la $a1, ARRAY_7
	add $a2, $zero, $s0
	jal accumulate_sum
	
	
	#go to the last element in array 7
	la $a1, ARRAY_7
loop_to_last_int:
	addi $s0, $s0, -1
	beq $s0, $zero, output_integer
	addi $a1, $a1, 4
	bne $s0, $zero, loop_to_last_int

	#output the last element in array 7
output_integer:
	add $v0, $zero, 1
	lw $a0, 0($a1)
	syscall
	
	
	
	# Get outta here.		
	add $v0, $zero, 10
	syscall	
	

	
# COPY YOUR PROCEDURES FROM PARTS A, B, C, and D BELOW
# THIS POINT.

# Accumulate sum: Accepts two integer arrays where the value to be
# stored at each each index in the *second* array is the sum of all
# integers from the index back to towards zero in the first
# array. The arrays are of the same size; the size is the third
# parameter.
#
accumulate_sum:
	lw $t1, 0($a0)		#load the value in the array
	
	add $t2, $t1, $t2	#sum the value with the previous value
	
	sw $t2, 0($a1)		#store the sum into the next spot in $a1 array
	
	addi $a1, $a1, 4
	addi $a0, $a0, 4
	
	addi $a2, $a2, -1
	bne $a2, $zero, accumulate_sum
	
		#reset temporary registers
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	
	jr $ra

# Accumulate max: Accepts two integer arrays where the value to be
# stored at each each index in the *second* array is the maximum
# of all integers from the index back to towards zero in the first
# array. The arrays are of the same size;  the size is the third
# parameter.
#
accumulate_max:
	lw $t1, 0($a0)				#load the value in the array
	
	slt $t3, $t1, $t5
	
	beq $t3, 1, current_max_is_max		#if the new number is less, input the current max into the new array
	beq $t3, $zero, new_number_is_max	#if the ne number is greater, input the new number in the array 

new_number_is_max:
	add $t5, $t1, $zero			#update the max
	sw $t1, 0($a1)				#inpout the new max
	
	addi $a1, $a1, 4
	addi $a0, $a0, 4
	
	addi $a2, $a2, -1
	bne $a2, $zero, accumulate_max


current_max_is_max:
	sw $t5, 0($a1)		#store the current max
	
	addi $a1, $a1, 4
	addi $a0, $a0, 4
	
	addi $a2, $a2, -1
	bne $a2, $zero, accumulate_max

		#reset temporary registers
	add $t1, $zero, $zero
	add $t3, $zero, $zero
	add $t5, $zero, $zero	
	jr $ra
	
	
# Reverse: Accepts an integer array, and produces a new
# one in which the elements are copied in reverse order into
# a second array.  The arrays are of the same size; 
# the size is the third parameter.
#
reverse_array:
	addi $t0, $a2, 0		#copy the number of integers in the array
	
	
	#go to the end of the array
go_to_end:
	addi $a2, $a2, -1
	beq $a2, $zero, store_array
	addi $a0, $a0, 4
	bne $a2, $zero, go_to_end

	#input the numbers from the given array into the new array, starting with the last number and moving to the first
store_array:
	lw $t1, 0($a0)
	sw $t1, 0($a1)
	
	addi $a1, $a1, 4
	addi $a0, $a0, -4
	
	addi $t0, $t0, -1
	bne $t0, $zero, store_array
	
		#reset temporary registers
	add $t0, $zero, $zero	
	add $t1, $zero, $zero
	jr $ra
	
	
# Reverse: Accepts three integer arrays, with the maximum
# element at each index of the first two arrays is stored
# at that same index in the third array. The arrays are 
# of the same size; the size is the fourth parameter.
#	
pairwise_max:
	lw $t1, 0($a0)		#load the values from the array
	lw $t2, 0($a1)		
	
	slt $t3, $t1, $t2	
	
	beq $t3, 1, array_1_has_max		#if array $a1 has the larger number, input that number into the new array
	beq $t3, $zero, array_0_has_max		#if array in $a0 has the larger number, input that number into the new array

array_0_has_max:
	sw $t1, 0($a2)				#store the bigger number into the new array
	
	addi $a1, $a1, 4
	addi $a0, $a0, 4
	addi $a2, $a2, 4
	
	addi $a3, $a3, -1
	bne $a3, $zero, pairwise_max
	beq $zero, $zero, go_back

array_1_has_max:
	sw $t2, 0($a2)				#store the bigger number into the new array
	
	addi $a1, $a1, 4
	addi $a0, $a0, 4
	addi $a2, $a2, 4
	
	addi $a3, $a3, -1
	bne $a3, $zero, pairwise_max


go_back:
		#reset temporary registers
	add $t1, $zero, $zero	
	add $t2, $zero, $zero
	add $t3, $zero, $zero	
	jr $ra
	


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
