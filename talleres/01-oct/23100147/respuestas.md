# Taller · quitar la mutación

Nombre: Marco Antonio Celis Mata  
Número de control: 23100147  
Equipo: 09  

| # | Función | ¿Qué muta la versión de TypeScript? | ¿Quién más se entera del cambio? |
| --- | --- | --- | --- |
| 1 | total_pesos | El acumulador | Local |
| 2 | marcar_urgentes | Los objetos prestados | Quien los tenga |
| 3 | aplicar_descuento | El arreglo prestado | Quien lo manda |
| 4 | contar_por_tipo | Contador local | Nadie |
| 5 | sin_duplicados | Set y el arreglo | Nadie |

¿Cuál de las cinco era la más peligrosa en TypeScript, y por qué? (dos líneas)

La segunda porque modifica un arreglo de objetos exterior y puede contener informacion muy importante, que no se podra recuperar.
