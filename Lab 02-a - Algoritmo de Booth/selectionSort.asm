.data
array: .space 400           # Space for 100 integers
newline: .asciiz "\n"
prompt_size: .asciiz "Ingrese el tamanio del arreglo: "
prompt_num: .asciiz "Ingrese un numero: "
result_text: .asciiz "Arreglo ordenado:\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, prompt_size
    syscall
    li $v0, 5
    syscall
    move $s1, $v0   
    
    blez $s1, exit
    li $t0, 100
    bgt $s1, $t0, exit

    la $s0, array           


    li $t0, 0
input_loop:
    bge $t0, $s1, sort_start
    li $v0, 4
    la $a0, prompt_num
    syscall
    li $v0, 5
    syscall
    sll $t1, $t0, 2
    add $t2, $s0, $t1
    sw $v0, 0($t2)
    addi $t0, $t0, 1
    j input_loop

sort_start:
    li $t0, 0               
outer_loop:
    addi $t3, $s1, -1       
    bge $t0, $t3, end_sort  

    move $t1, $t0          
    addi $t2, $t0, 1        
inner_loop:
    bge $t2, $s1, swap      

    sll $t4, $t2, 2
    add $t4, $s0, $t4
    lw $t5, 0($t4)          
    sll $t6, $t1, 2
    add $t6, $s0, $t6
    lw $t7, 0($t6)          

    ble $t5, $t7, skip      
    move $t1, $t2           

skip:
    addi $t2, $t2, 1
    j inner_loop

swap:
    sll $t4, $t0, 2
    add $t4, $s0, $t4
    sll $t6, $t1, 2
    add $t6, $s0, $t6
    lw $t5, 0($t4)          
    lw $t7, 0($t6)          
    sw $t7, 0($t4)          
    sw $t5, 0($t6)          

    addi $t0, $t0, 1
    j outer_loop

end_sort:
    li $v0, 4
    la $a0, result_text
    syscall

    li $t0, 0
print_loop:
    bge $t0, $s1, exit
    sll $t1, $t0, 2
    add $t1, $s0, $t1
    lw $a0, 0($t1)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    addi $t0, $t0, 1
    j print_loop

exit:
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 10
    syscall