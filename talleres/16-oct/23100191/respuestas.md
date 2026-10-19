# Taller 3 · La mutación escondida

Nombre: Orea Rafael  
Número de control: 23100191  
Equipo: 09

## 1 · Antes y después de ejecutar

| Línea | Predigo | Salió |
| --- | --- | --- |
| 1 · | `B,A true` | `B,A true` |
| 2 · | `10 true` | `10 true` |
| 3 · | `2 true` | `2 true` |
| 4 · | `SCT-77 false` | `SCT-77 false` |
| 5 · | `15 15` | `15 15` |

## 2 · Qué se muta y quién se entera

| # | Función | ¿Qué línea muta, y qué cambia? | ¿Quién más se entera del cambio? |
| --- | --- | --- | --- |
| 1 | ordenarPorPeso | `embarques.sort(...)` cambia el orden del arreglo recibido. | Quien conserve una referencia a ese arreglo, como `lote`. |
| 2 | conDescuento | `reglas.descuentoPct = pct` cambia el descuento del objeto recibido. | Quien use las mismas reglas, como `base`. |
| 3 | registrar | `vistos.push(id)` agrega un elemento al arreglo global. | Todas las llamadas y quienes guardaron el arreglo devuelto, como `primera`. |
| 4 | conPermiso | `copia.documentos.permiso = permiso` cambia el objeto anidado que comparte con el original. | Quien tenga ese objeto de documentos, incluido `original`. |
| 5 | fechaDeEntrega | `salida.setDate(...)` cambia el día de la fecha recibida. | Quien conserve esa misma fecha, como `salida`. |

## 3 · Tres preguntas cortas

**a)** En la línea 4 salió `false` en `original === conP`, y aun así el original cambió. ¿Cómo es posible?

El spread crea un objeto exterior nuevo, pero ambos conservan la referencia al mismo objeto `documentos`. Cambiar su permiso también se refleja en el original.

**b)** ¿Por qué `registrar` no es una función pura?

Modifica un arreglo global y su resultado depende de las llamadas anteriores, además del argumento recibido.

**c)** En tus pruebas de Elixir, la última aserción de cada una revisa que el original sigue igual. ¿Por qué en Elixir esa aserción no puede fallar?

Los datos de Elixir son inmutables. Ordenar, actualizar un mapa, agregar un elemento o sumar días produce un valor nuevo y conserva el original, incluso cuando hay mapas anidados.
