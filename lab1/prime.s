.data
	input_msg:	 .asciiz "Please input a number: "
	output_msg1: .asciiz "It's a prime\n"
	output_msg2: .asciiz "It's not a prime\n"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg on the console interface
	li $v0, 4				
	la $a0, input_msg		
	syscall                 
		
# read the input integer -> $a0 (use as an argument)
	li $v0, 5          	
	syscall                 	
	or $a0, $v0, $zero    		

# jump to procedure prime
  	jal prime	
	or $t0, $v0, $zero # save return value in $t0 (since we will need to use $v0 for syscall 10)
# check the return value and output
	beq $t0, $zero, not_prime
	bne $t0, $zero, is_prime

# print is_prime on the console interface
is_prime:	
	li $v0, 4			    
	la $a0, output_msg1    
	syscall
	# exit 
	li $v0, 10
	syscall

# print not_prime on the console interface	
not_prime:	
	li $v0, 4			    
	la $a0, output_msg2    
	syscall
	# exit             
	li $v0, 10	
	syscall	
	
#------------------------- procedure prime -----------------------------
.text
prime:
	# if n == 1 -> return 0
	addi $t0, $zero, 1
	beq $v0, $t0, return0
	# $t1 is the loop index	
	addi $t1, $zero, 2

Loop:		
    mul $t0, $t1, $t1
	# go to return1 if n < i*i	(exit the loop)	
	slt $t2, $a0, $t0 		
	bne $t2, $zero, return1
	
	# loop
	div $a0, $t1 # Divide n (in $a0) by i (in $t1)
	# places the quotient in the special register LO and the remainder in the special register HI.
	# so we need to move the remainder from HI to $t3
	mfhi $t3 # get n%i (the remainder) in $t3

	# if(n%i == 0) return 0;
	beq $t3, $zero, return0	
	# loop index ++	
	addi $t1, $t1, 1
	j Loop

return1:		
    addi $v0, $zero, 1 # return 1
	jr $ra
	
return0:		
    addi $v0, $zero, 0 # return 0
	jr $ra

