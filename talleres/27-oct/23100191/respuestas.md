# Taller 5 · Composición o herencia

Nombre: Orea Rafael  
Número de control: 23100191  
Equipo: 09  

## Paso 1 · La herencia

**a)** ¿En qué dos clases está escrito el cálculo del seguro? ¿Por qué no se pudo escribir una sola
vez?

En `ConSeguro` y `RefrigeradaConSeguro`. Esta última hereda de `Refrigerada` y TypeScript no permite heredar también de `ConSeguro`, así que repite el cálculo del seguro.

**b)** Con un tercer extra (express), ¿cuántas clases hacen falta para todas las combinaciones?
¿Cuántas son nuevas? Muestra la cuenta.

Cada extra puede estar presente o ausente: 2 × 2 × 2 = 8 clases en total. Ya hay 4, así que hacen falta 4 clases nuevas.

## Paso 2 · La composición

**c)** Para agregar express a `composicion.ts`, ¿qué agregaste? ¿Cambió `cotizar`?

Agregué la función `express`, que suma 50000 centavos. `cotizar` no cambió porque aplica cualquier lista de ajustes.

## Paso 3 · El orden

| Llamada | Predigo | Salió |
|---|---:|---:|
| `cotizar(100, 1000, [express, seguro])` | 153000 | 153000 |
| `cotizar(100, 1000, [seguro, express])` | 152000 | 152000 |

**d)** ¿Por qué salen distintos? (dos líneas)

Con `express` primero, el seguro calcula el 2 % sobre el flete más los 50000 centavos del express.
Con `seguro` primero, ese monto fijo se suma después y no forma parte de la base del porcentaje.

## Paso 4 · Sostén la decisión

**e)** En su modelo del proyecto, ¿cómo están escritos los pasos del cálculo: con herencia o con
composición? Cita el archivo y la función.

Con composición. En `src/modelo.ts`, `cotizar` llama a `validar` y luego a `calcular`. Esta última combina funciones como `calcularDescuento` y `pct` para obtener la cotización, sin herencia.

**f)** Da **un** caso, en su proyecto o fuera de él, donde sí usarías herencia, y di por qué ahí no
hay explosión de combinaciones. (tres líneas)

Usaría `EmbarqueRechazado extends Error` para representar un error del cotizador.
Hereda el mensaje y el rastro de pila que comparten todos los errores.
No hay combinaciones que cubrir, así que basta una clase.
