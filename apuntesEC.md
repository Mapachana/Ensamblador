# Programa EC

## Programa

```assamble
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

```assembly
mov (%eax, %eax, 2), %eax
leal(%eax, %eax, 2), %eax
```

Aquí _eax_ es 3.

## Operaciones aritméticas








