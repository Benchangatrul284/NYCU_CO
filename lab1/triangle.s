.data
	input_msg1:	 .asciiz "Please enter option (1: triangle, 2: inverted triangle): "
    input_msg2:	 .asciiz "Please input a triangle size: "
    space: .asciiz " "
	star: .asciiz "*"
    newline: .asciiz "\n"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg1 on the console interface
	li $v0, 4				
	la $a0, input_msg1		
	syscall                 	

# s1 -> op
# read the input integer -> $s1
	li $v0, 5          	
	syscall
    or $s1, $v0, $zero

# print input_msg2 on the console interface
	li $v0, 4				
	la $a0, input_msg2		
	syscall 

# s2 -> n		
# read the input integer -> $s2
	li $v0, 5
	syscall
	or $s2, $v0, $zero

    # s7 -> loop index
    or $s7, $zero ,$zero   

Loop:
    #　if (i>=n) exit the loop
    slt $t1, $s7, $s2
    beq $t1, $zero, exit
    
    addi $t1, $zero, 1 # t1 = 1
    beq $s1, $t1, is_equal # (op==1)
    bne $s1, $t1, not_equal # (op!=1)

is_equal:
    addi $t2, $zero, 1 # t2 = 1
    jal Con1
    addi $s7, $s7, 1
    j Loop

not_equal:
    addi $t2, $zero, 0 # t2 = 0
    jal Con2
    addi $s7, $s7, 1
    j Loop

# call the print_layer procedure
# $a1 -> n, $a2 -> i
# print_layer(n, i);
Con1:
    or $a1, $s2, $zero
    or $a2, $s7, $zero
    j print_layer
# print_layer(n, n-i-1);
Con2:
    or $a1, $s2, $zero
    or $a2, $s2, $zero
    sub  $a2, $a2, $s7
    addi $a2, $a2, -1
    j print_layer   

#------------------------- procedure print_layer -----------------------------
# a1 -> n, a2 -> l
print_layer:
    # $s6 is the loop index
    addi $s6, $zero, 1 
    j print_space

print_space:
    # if (j < n-l) exit the loop
    sub  $s3, $a1, $a2 # upper bound
    # if (j < n-l) exit the loop (go to print_star)
    slt $t7, $s6, $s3
    beq $t7, $zero, print_star 

    # print space on the console interface
	li $v0, 4
	la $a0, space
	syscall
    # loop index ++
    addi $s6, $s6, 1
    j print_space

print_star:
    # upper bound
    add  $s4, $a1, $a2
    addi $s4, $s4, 1
    # if (j < n+l+1) exit the loop
    slt $t7, $s6, $s4 
    beq $t7, $zero, print_newline

    # print output_msg2 on the console interface
	li $v0, 4
	la $a0, star
	syscall
    # loop index ++
    addi $s6, $s6, 1    
    j print_star

print_newline:
    # print output_msg3 on the console interface
	li $v0, 4
	la $a0, newline
	syscall
    j $ra # return to main function

exit:
    li $v0, 10
	syscall