# Declaramos seccion de datos del programa
.section .data

	lista: .int 1, 2, -3, -4, 1, 2, -3, -2, 1, 2, -3, -4, 1, 3, 4, 2, 3, 4, -2, -3, -4, 1, 2, -2, 1, 2, -2, 1, 2, 4, -3, -4 
	longlista: .int (.-lista)/4
	resultado: .quad -1
	formato: .ascii "La suma de los numeros es: %i\n\0"

# Declaramos la seccion de texto del programa.
.section .text
# Declaramos la seccion de comienzo del programa.
main:	.global main

	mov $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %eax, resultado
	mov %edx, resultado+4
	
	#Mostrar resultado por pantalla
	push resultado
	push $formato
	call printf
	add $8, %esp
	
	#Ajuste final y fin de programa
	mov $1, %eax							
	mov $0, %ebx
	int $0x80
	

suma:
	push %esi
	
	mov $0, %eax #Almacenaremos elementos de la lista aqui.
	mov $0, %edx #Extension de eax.
	mov $0, %esi #Iterador

bucle:
	add (%ebx,%esi,4), %eax
	adc $0, %edx
	inc %esi
	cmp %esi, %ecx
	jne bucle
	
	pop %esi
	ret
