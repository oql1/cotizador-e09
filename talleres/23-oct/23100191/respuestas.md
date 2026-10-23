# Taller 4 · De condicionales a despacho

Nombre: Orea Rafael  
Número de control: 23100191  
Equipo: 09  

## Paso 1 · La versión con switch

**a)** Antes de tocar nada: ¿cuántos lugares de `condicionales.ts` hay que cambiar para agregar
`perecedera`?

Cuatro lugares: el tipo `Tipo` y los tres `switch` de `recargo`, `documentoRequerido` y `etiqueta`.

**b)** Después de agregar `'perecedera'` solo al tipo: ¿qué dijo `tsc`, y qué imprimió la
demostración para perecedera?

`tsc` no mostró errores. La demostración imprimió `perecedera  0  null  General`.

**c)** ¿Por qué el compilador no te avisó? (una línea)

Los tres `switch` tienen un `default`, así que TypeScript considera cubierto el tipo nuevo aunque caiga en una política incorrecta.

## Paso 3 · La versión con tabla

**d)** Después de agregar `'perecedera'` al tipo: ¿qué dijo `tsc`? Copia el mensaje.

`tsc` mostró:

```text
src/despacho.ts(13,14): error TS2741: Property 'perecedera' is missing in type '{ general: { pct: number; fija: number; documento: null; etiqueta: string; }; refrigerada: { pct: number; fija: number; documento: null; etiqueta: string; }; peligrosa: { pct: number; fija: number; documento: "numeroUn"; etiqueta: string; }; sobredimensionada: { ...; }; }' but required in type 'Record<Tipo, Politica>'.
```

**e)** ¿Cuántos lugares cambiaste en `despacho.ts` para agregar perecedera?

Un lugar: agregué la entrada `perecedera` a `POLITICAS`.

## Los dos lenguajes

**f)** En su motor de Elixir, ¿qué pasa si llega un tipo de carga para el que no hay cláusula? ¿Y en
`despacho.ts`, si a la tabla le falta un tipo? ¿Cuál de los dos te avisa antes, y cuándo? (dos líneas)

En nuestro `Cotizador.cotizar/2`, un tipo desconocido devuelve `{:error, :tipo_desconocido}` por la validación previa. Si una función de Elixir no tiene una cláusula aplicable, produce `FunctionClauseError` al ejecutarla.

En TypeScript, `Record<Tipo, Politica>` avisa al compilar cuando falta una entrada de la tabla, antes de ejecutar el programa.
