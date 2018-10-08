# Declaramos secciond e datos del programa
.section .data
 #Aqui se declara la lista, con elementos 1,2,10,1,2,10(binario),1,2,10(hexadecimal)
lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10
# Guardamos lal ongitud de la lista, el punto accede a la direccion de memoria actual, entonces la direccion de memoria actual menos la 
# direccion de mmemoria donde comienza la lista es la cantidad de memoria total que ocupa, ahora la dividimos entre 4 que es lo que ocupa el
# tipo de dato entero que es lo que almacena la lista, asi obtenemos el numero de elementos.
longlista:	.int (.-lista)/4
# Declaramos una variable resultado donde se almacenara el resultado de la suma, la inicializamos a -1
resultado:	.int -1

# Declaramos la seccion de texto del programa.
.section .text
# Declaramos la seccion de comienzo del programa.
_start:	.global _start

# Guardamos la direccion de memoria donde comienza la lista en ebx
	mov    $lista, %ebx
# Guardamos la longitud de l alista en ecx
	mov longlista, %ecx
# Llamamos a la funcion suma, que comienza en "suma:"
	call suma
# Aqui ya hemos realizado la funcion suma, y movemos eax al resultado.
	mov %eax, resultado

# Estas tres instrucciones son las de salida del programa.
	mov $1, %eax
	mov $0, %ebx
	int $0x80

# Aqui comienza la funcionn suma
suma:
# Metemos en la pila edx, para luego volver por donde ibamos
	push %edx
# Ponemos un 0 en eax
	mov $0, %eax
# Ponemos nu 0 en edx
	mov $0, %edx
# Esto sigue dentro de suma, a partirt de aqui se realizara un bucle
bucle:
# Sumamos ebx con edx y con 4, almacenando el resultado en eax ¿Por que?
################EXPLICACION##################
# ebx tiene la direccion base de la lista en memoria, vamos a ir sumandole edx y 4 de forma progresiva.
# ¿por que el 4? El 4 hace referencia al tipo de dato almacenado en la lista, en este caso entero, es loq eu ocupa cada entero.
# edx,4 es equivalent a edx*4, esto es, edx indica a que elemento de la lista se accede, ya que es:
# ebx+0*4=ebx. elemento 0
# ebx+1*4=ebx+4. elemento 1.
# Asi sucesivamente.
# luego edx es el indice del bucle, el equivalente a for(i)
###############################################3
	add (%ebx,%edx, 4), %eax
# Esta instruccion incrementa en uno edxz, el indice.
	inc       %edx
# En esta instruccion se compara edx con ecx, donde ecx recordamos es el numero de elementos de la lista, es decir, es la
# condicion de salida, si el indicce es igual al numero de elementos de  la lista entonces...
	cmp  %edx,%ecx
# jne significa "jump if not equal", luego si la comparacion anterior es falsa (no son iguales) el programa vuelve a la etiqueta "bucle:"
# pero si son iguales, se ignora esta instruccion y se sigue el programa. Es similar a un if.
	jne bucle

# Con pop accedemos a la pila restaurando edx al valor de antes de llamar a la funcion, estas instruccion pop y ret se usan para salir.
	pop %edx
	ret
