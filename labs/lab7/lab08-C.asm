	.text  
main:
	# Must enable the keyboard device (i.e., in the "MMIO" simulator) to
	# generate interrupts. 0xffff0000 is the location in kernel memory
	# mapped to the control register of the keybaord.
	
	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)

	# We'll keep incrementing $t5 every time through the loop below.
	# $t6 will be incremented each time there is a keyboard interrupt.
	# $t7 will hold the ASCII code of the most-recently pressed key.
	# (By "key", we mean key pressed in the "Keyboard and Display MMIO Simulator".)
	
	add $t5, $zero, $zero
	add $t6, $zero, $zero
	
forever_loop:
	addi $t5, $t5, 1
	beq $zero, $zero, forever_loop



	.kdata
	
	# No data in the kernel-data section (at present)

	.ktext 0x80000180	# Required address in kernel space for exception dispatch
__kernel_entry:
	mfc0 $k0, $13		# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c	# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2	# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt
	
__is_exception:
	# Something of a placeholder...
	# ... just in case we can't escape the need for handling some exceptions.
	beq $zero, $zero, __exit_exception
	
__is_interrupt:
	andi $k1, $k0, 0x0100	# examine bit 8
	bne $k1, $zero, __is_keyboard_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	
	beq $zero, $zero, __exit_exception	# otherwise, we return exit kernel
	
__is_keyboard_interrupt:
	addi $t6, $t6, 1
	la $k0, 0xffff0004
	lw $t7, 0($k0)	
	# Note: We could also take the value obtained from the "lw:
	# and store it someplace in data memory. However, to keep
	# things simple, we're using $t7 immediately above.
	
	beq $zero, $zero, __exit_exception	# Kept here in case we add more handlers.
	
	
__exit_exception:
	eret
	
