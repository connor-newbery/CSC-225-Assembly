# Skeleton file provided to students in UVic CSC 230, Spring 2022
# Original file copyright Mike Zastre, 2022
#Connor Newbery, V00921506

.include "a4support.asm"


.globl main

.text 

main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $a0, FILENAME_1
	la $a1, ARRAY_A
	jal read_file_of_ints
	add $s0, $zero, $v0	# Number of integers read into the array from the file
	
	la $a0, ARRAY_A
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part A test
	#
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	add $a2, $zero, $s0
	jal accumulate_sum
	
	
	la $a0, ARRAY_B
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part B test
	#
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	add $a2, $zero, $s0
	jal accumulate_max
	
	la $a0, ARRAY_B
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part C test
	#
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	add $a2, $zero, $s0
	jal reverse_array
	
	la $a0, ARRAY_B
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part D test
	la $a0, FILENAME_1
	la $a1, ARRAY_A
	jal read_file_of_ints
	add $s0, $zero, $v0
	
	la $a0, FILENAME_2
	la $a1, ARRAY_B
	jal read_file_of_ints
	# $v0 should be the same as for the previous call to read_file_of_ints
	# but no error checking is done here...
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	la $a2, ARRAY_C
	add $a3, $zero, $s0
	jal pairwise_max
	
	la $a0, ARRAY_C
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Get outta here...
	add $v0, $zero, 10
	syscall	
	
	
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
	

.data

.eqv	MAX_ARRAY_SIZE 1024

.align 2

ARRAY_A:	.space MAX_ARRAY_SIZE
ARRAY_B:	.space MAX_ARRAY_SIZE
ARRAY_C:	.space MAX_ARRAY_SIZE

FILENAME_1:	.asciiz "integers-10-314.bin"
FILENAME_2:	.asciiz "integers-10-1592.bin"


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# In this region you can add more arrays and more
# file-name strings. Make sure you use ".align 2" before
# a line for a .space directive.


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
