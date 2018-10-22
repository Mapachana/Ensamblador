# Declaramos seccion de datos del programa
.section .data

	lista: .int 1, 2, -3, -4, 1, 2, -3, -2, 1, 2, -3, -4, 1, 3, 4, 2, 3, 4, -2, -3, -4, 1, 2, -2, 1, 2, -2, 1, 3, 31, -3, -4
	longlista: .int (.-lista)/4
	sumaa: .quad -1
	media: .int -1
	resto: .int -1
	formatosuma: .ascii "La suma de los numeros es: %i\n\0"
	formatomedia: .ascii "La media de los numeros es: %i\n\0"
	formatoresto: .ascii "El resto de la división es: %i\n\0"

# Declaramos la seccion de texto del programa.
.section .text
# Declaramos la seccion de comienzo del programa.
main:	.global main

	mov $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %eax, sumaa
	mov %edx, sumaa+4
	cdq #Extiende eax a edx:eax
	idiv %ecx
	mov %eax, media
	mov %edx, resto
	
	#Mostrar resultado por pantalla
	push sumaa
	push $formatosuma
	call printf
	add $8, %esp
	push media
	push $formatomedia
	call printf
	add $8, %esp
	push resto
	push $formatoresto
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
