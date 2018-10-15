# Apuntes EC

## Programa inicial

```shell
swap:
    #Ajuste inicial
    push1 %ebp
    mov1 %esp,%ebp
    push1 %ebx

    #Cuerpo
    mov1 8(%ebp), %edx
    mov1 12(%ebp), %ecx
    mov1 (%edx), %ebx
    mov1 (%ecx), %eax
    mov1 %eax, (%edx)
    mov1 %ebx, (%ecx)

    #Fin
    pop1 %ebx
    pop1 %ebp
    ret
```

- Ajuste inicial:
  - Con la primera instrucción pasamos la variable %ebp en la pila (en la parte de abajo, la más acctual)
  - Con la segunda instrucción hacemos que el puntero de pila, esp, guardamos a donde apunte en ebp.
  - Con la tercera instrucción metemos la variable ebx en la pila.
- Cuerpo:
  - Cada dato ocupa 4 bytes, y las posiciones de memoria también ocupan 4. Si ebp sigue apuntando a donde al principio, tenemos que sumar 4 para subir cada escalerita, entonces 4 para dirección de retorno y, en total, 8 para la variable pasada como argumento a la función, que es edx.
  - En este caso, para recuperar el segundo parámetro de la función sumamos 12 y lo metemos en ecx.
  - Aquí cogemos lo que hay en el registro (por eso los paréntesis) en ebx, porque edx es un puntero y almacena una dirección de memoria, y queremos copiar el dato de la dirección a la que apunta.
  - Esta operación es análoga a la anterior moviendo la memoria que hay del sitio al que apunta ecx en eax.
  - En esta instrucción movemos el dato que hay en eax y lo movemos a la memoria de la direccióna  la que apunta edx.
  - Esta instrucción se hace de forma análoga moviendo de ebx a la dirección apuntada por ecx.
- Fin
  - Con la primera instrucción  quitamos ebx de la pila y %esp (el puntero de pila) vuelve a apuntar a %ebp.
  - De nuevo, quitamos %ebp de la pila, moviéndose y se restaura el %esp, que sube.
  - Al hacer ret cojo la condición de retorno y vuelvo a mi programa original.

El código en ensamblador de arriba es equivalente a este código en c:    

```c
void swap(int *xp, int *yp)
{
    int t0 = *xp;
    int t1 = *yp;
    *xp = t1;
    *yp = t0;
}
```

## Programa de prácticas

Este programa realiza una suma sin tener en cuenta el acarreo.

```shell
# Declaramos seccion de datos del programa
.section .data
 #Aqui se declara la lista, con elementos 1,2,10,1,2,10(binario),1,2,10(hexadecimal)
lista:        .int 1,2,10,  1,2,0b10,  1,2,0x10
# Guardamos la longitud de la lista, el punto accede a la direccion de memoria actual, entonces la direccion de memoria actual menos la direccion de memoria donde comienza la lista es la cantidad de memoria total que ocupa, ahora la dividimos entre 4 que es lo que ocupa el tipo de dato entero que es lo que almacena la lista, asi obtenemos el numero de elementos.
longlista:    .int (.-lista)/4
# Declaramos una variable resultado donde se almacenara el resultado de la suma, la inicializamos a -1
resultado:    .int -1

# Declaramos la seccion de texto del programa.
.section .text
# Declaramos la seccion de comienzo del programa.
_start:    .global _start

# Guardamos la direccion de memoria donde comienza la lista en ebx
    mov    $lista, %ebx
# Guardamos la longitud de la lista en ecx
    mov longlista, %ecx
# Llamamos a la funcion suma, que comienza en "suma:"
    call suma
# Aqui ya hemos realizado la funcion suma, y movemos eax al resultado.
    mov %eax, resultado

# Estas tres instrucciones son las de salida del programa.
    mov $1, %eax
    mov $0, %ebx
    int $0x80

# Aqui comienza la funcion suma
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
##################################EXPLICACION#####################################
# ebx tiene la direccion base de la lista en memoria, vamos a ir sumandole edx y 4 de forma progresiva.
# ¿por que el 4? El 4 hace referencia al tipo de dato almacenado en la lista, en este caso entero, es loq eu ocupa cada entero.
# edx,4 es equivalent a edx*4, esto es, edx indica a que elemento de la lista se accede, ya que es:
# ebx+0*4=ebx. elemento 0
# ebx+1*4=ebx+4. elemento 1.
# Asi sucesivamente.
# luego edx es el indice del bucle, el equivalente a for(i)
###################################################################################
    add (%ebx,%edx, 4), %eax
# Esta instruccion incrementa en uno edxz, el indice.
    inc       %edx
# En esta instruccion se compara edx con ecx, donde ecx recordamos es el numero de elementos de la lista, es decir, es la
# condicion de salida, si el indicce es igual al numero de elementos de  la lista entonces...
    cmp  %edx,%ecx
# jne significa "jump if not equal", luego si la comparacion anterior es falsa (no son iguales) el programa vuelve a la etiqueta "bucle:" pero si son iguales, se ignora esta instruccion y se sigue el programa. Es similar a un if.
    jne bucle

# Con pop accedemos a la pila restaurando edx al valor de antes de llamar a la funcion, estas instruccion pop y ret se usan para salir.
    pop %edx
    ret
```

## Push y Pop

Supongamos que en un lenguaje de alto nivel meter una variable A en pila, es decir, `push A`.

Esto equivale a:

```shell
sub $4, %esp
mov A, (%esp)
```

Porque a la dirección por donde va la pila (esp) le restamos 4 para hacer sitio para la variable nueva (4 por ser entero en 32 bits) y movemos el valor de A a donde esta apuntando esp (por eso el parentesis, es puntero).

Si quisiéramos hacer `pop A`:

```shell
mov (%esp), A
add $4, %esp
```

Por motivos análogos al razonamiento del ejemplo anterior.

## Registros e importancia

- Temporales, no hace falta guardarlos: eax, edx, ecx

- Temporales pero debo guardarlos: ebx, esi, edi

- Especiales: esp, ebp

_Para guardar un registro se le hará push a la pila_
