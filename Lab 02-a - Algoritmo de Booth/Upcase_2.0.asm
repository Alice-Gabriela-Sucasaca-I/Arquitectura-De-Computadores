.text
.globl __start
__start:

# Mostrar el mensaje para pedir cadena
#la $a0, prm_input
#li $v0, 4
#syscall

    # Leer cadena ingresada por el usuario
#la $a0, buffer      # dirección donde se guardará la cadena
#li $a1, 100         # longitud máxima a leer
#li $v0, 8           # syscall para leer string
#syscall


la $a0, prm1
li $v0,4
syscall
la $a0, orig
li $v0,4
syscall
la $s0, orig
li $t0,0                  # contador
li $t2,1                  # lei un espacio
li $t3,0                  # indicador de rango minusculas
li $t4,0
li $t6, 0x20              # ASCII space
li $t7, 0x61              # ASCII 'a'
li $t8, 0x7a              # ASCII 'z'
add $t0, $t0, $s0
loop:                     # bucle barrer cadena y alterar
lb $t1, 0($t0)
beq $t1,$zero,endLoop     # caracter null, fin de barrido
slt $t3,$t1,$t7           # t3 = 1 si t1 < 0x61
slt $t4,$t8,$t1           # t4 = 1 si t1 > 0x7a
or $t3,$t3,$t4            # 1 -> fuera de min
beq $t2,$zero, nospace    # si no se leyo espacio antes
bne $t3,$zero, nospace    # si no esta en rango minusc
addi $t1,$t1,-32         # convierte en may
sb $t1,0($t0)             # graba byte cambiado
nospace:
bne $t1,$t6, nospacenow   # si ahora no leyo espacio
li $t2, 1                 # se leyo espacio
j endspace
nospacenow:
li $t2, 0
endspace:
addi $t0,$t0,1
j loop
endLoop:
la $a0, prm2
li $v0,4
syscall
la $a0, orig
li $v0,4
syscall
li $v0, 10                 # finish
syscall
.data
orig: .asciiz "la cadena original con letras todas minusculas"
prm1: .asciiz "Original: "
prm2: .asciiz "\nUpcased : "
#buffer: .space 100