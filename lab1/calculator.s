.data
prompt1: .asciiz "Please enter option (1: add, 2: sub, 3: mul): "
prompt2: .asciiz "Please enter the first number: "
prompt3: .asciiz "Please enter the second number: "
output_msg: .asciiz "The calculation result is: "
newline: .asciiz "\n"

.text
.globl main
main:
# print prompt1 on the console interface
    li $v0, 4 
    la $a0, prompt1 
    syscall

# read user input value -> $t0
    li $v0, 5 
    syscall
    or $t0, $v0, $zero

# print prompt2 on the console interface
    li $v0, 4
    la $a0, prompt2
    syscall

# read user input value -> $t1
    li $v0, 5
    syscall
    or $t1, $v0, $zero

# print prompt3 on the console interface
    li $v0, 4
    la $a0, prompt3
    syscall

# read user input value -> $t2
    li $v0, 5
    syscall
    or $t2, $v0, $zero

# perform branching operation
    beq $t0, 1, op1
    beq $t0, 2, op2
    beq $t0, 3, op3
    j end

# perform operation and jump 
op1:
    add $t3, $t1, $t2
    j print

op2:
    sub $t3, $t1, $t2
    j print

op3:
    mul $t3, $t1, $t2
    j print

print:
# print output_msg on the console interface
    li $v0, 4
    la $a0, output_msg
    syscall
# print result on the console interface ($t3->$a0)
    li $v0, 1
    or $a0, $t3, $zero
    syscall

# print new line
	li $v0, 4
    la $a0, newline
    syscall

end:
    # Exit
    li $v0, 10
    syscall