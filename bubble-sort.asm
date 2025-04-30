.data
    nodo_array: .space 1200          
    str_prompt_size: .asciiz "Ingrese el tamanio de la lista: "
    str_prompt_dato: .asciiz "Ingrese un numero: "
    str_result: .asciiz "Lista ordenada:\n"
    str_space: .asciiz " "
    str_newline: .asciiz "\n"

.text
.globl main

main:
    # Pedir tamaio de la lista
    li $v0, 4
    la $a0, str_prompt_size
    syscall

    li $v0, 5
    syscall
    move $s1, $v0      # $s1 = tamanio

    blez $s1, exit     # Si <= 0, salir
    li $t0, 100
    bgt $s1, $t0, exit

    la $s0, nodo_array # $s0 apunta al inicio del array de nodos
    li $t1, 0          # Índice del nodo

build_list:
    bge $t1, $s1, sort_start

    li $v0, 4
    la $a0, str_prompt_dato
    syscall

    # Leer dato
    li $v0, 5
    syscall
    move $t2, $v0      # $t2 = dato

    # Calcular direccion de nodo: base + (indice * 12)
    mul $t3, $t1, 12
    add $t4, $s0, $t3

    # Guardar dato
    sw $t2, 0($t4)

    li $t5, 0
    sw $t5, 4($t4)

    beqz $t1, no_prev
    mul $t6, $t1, 12
    sub $t6, $t6, 12
    add $t6, $s0, $t6
    sw $t6, 8($t4)     

    sw $t4, 4($t6)
no_prev:

    addi $t1, $t1, 1
    j build_list

sort_start:
    move $a0, $s0         
    jal bubbleSort

    # Imprimir resultado
    li $v0, 4
    la $a0, str_result
    syscall

    move $a0, $s0
    jal imprimirLista
    j exit

# ordenar por dato intercambiando datos entre nodos

bubbleSort:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    move $s0, $a0         
    li $s1, 0             
bucle_externo:
    li $s2, 0             
    move $t0, $s0        

bucle_interno:
    lw $t1, 4($t0)        
    beq $t1, $s1, fin_bucle_interno
    beqz $t1, fin_bucle_interno

    lw $t2, 0($t0)        
    lw $t3, 0($t1)        
    ble $t2, $t3, no_swap

    # Intercambiar datos
    sw $t3, 0($t0)
    sw $t2, 0($t1)
    li $s2, 1

no_swap:
    move $t0, $t1
    j bucle_interno

fin_bucle_interno:
    move $s1, $t0
    beq $s2, 1, bucle_externo

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# imprimirLista
imprimirLista:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    move $s0, $a0
print_loop:
    beqz $s0, fin_imprimir
    lw $a0, 0($s0)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, str_space
    syscall
    lw $s0, 4($s0)
    j print_loop

fin_imprimir:
    li $v0, 4
    la $a0, str_newline
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

exit:
    li $v0, 10
    syscall
