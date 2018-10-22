# Declaramos seccion de datos del programa
.section .data

	lista: .int 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 999999999
	longlista: .int (.-lista)/4
	resultado: .quad -1
	formato: .ascii "La suma es: %u\n\0"

# Declaramos la seccion de texto del programa.
.section .text
# Declaramos la seccion de comienzo del programa.
main: .global main
#_start:	.global _start

	mov $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %eax, resultado
	mov %edx, resultado+4

	# Escribir en pantalla
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
	
	mov $0, %eax
	mov $0, %edx
	mov $0, %esi

bucle:
	add (%ebx,%esi,4), %eax
# COn adc se tiene en cuenta los flags y el flag de acarreo salta, se le suma 0 para wue se le sume el acarreo al siguiente
	adc $0, %edx
	inc %esi
	cmp %esi, %ecx
	jne bucle
	
	# Con pop accedemos a la pila restaurando edx al valor de antes de llamar a la funcion, estas instruccion pop y ret se usan para salir.	
	 pop %esi

	ret
