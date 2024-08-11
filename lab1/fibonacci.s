.data
	input_msg:	.asciiz "Please input a number: "
    output_msg: .asciiz "The result of fibonacci(n) is "
	newline:	.asciiz "\n"
.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg1 on the console interface
	li $v0, 4
	la $a0, input_msg
	syscall

# read the input integer -> $a0 (use as an argument)
	li $v0, 5
	syscall
	or $a0, $v0, $zero
    
# jump to procedure fibonacci
	jal fibonacci
	or 	$t0, $v0, $zero

# print output_msg on the console interface
	li      $v0, 4		
	la      $a0, output_msg
	syscall

# print the result ($a0)
	or $a0, $t0, $zero
	li $v0, 1
	syscall

# print new line
	li $v0, 4				
	la $a0, newline
	syscall	

# exit the program
	li $v0, 10
	syscall

#------------------------- procedure fibonacci -----------------------------
# load argument n in $a0, return value in $v0. 
.text
fibonacci:
# push the stack
    addi 	$sp, $sp, -16 
    sw 		$ra, 12($sp)     
	sw 		$s0, 8($sp) # store current n
	sw 		$s1, 4($sp)	# store fibonacci(n-1)
	sw 		$s2, 0($sp)	# store fibonacci(n-2)

	or 	$s0, $a0, $zero # store current n
	#　if n == 0, return 0
    addi    $v0, $zero, 0
    beq     $a0, $v0, return
    # if n == 1, return 1
    addi    $v0, $zero, 1
	beq    $a0, $v0, return

    addi  $a0, $s0, -1 # n = n-1
    jal fibonacci
	or $s1, $v0, $zero # store fibonacci(n-1)

    addi   $a0, $s0, -2  # n = n-2
    jal fibonacci
	or $s2, $v0, $zero # store fibonacci(n-2)
    add $v0, $s2, $s1 # return fibonacci(n-1) + fibonacci(n-2)

return:
# pop the stack		
	lw      $s2, 0($sp)
    lw      $s1, 4($sp)
    lw      $s0, 8($sp)
    lw      $ra, 12($sp)
    addi    $sp, $sp, 16
# return to the caller
	jr 	    $ra