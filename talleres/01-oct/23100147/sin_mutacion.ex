defmodule SinMutacion do
  @moduledoc """
  Martes 29 · Taller: quitar la mutacion.

  Cada funcion es la traduccion de una funcion imperativa de TypeScript que esta en
  `../imperativo.ts`. Alla mutan. Aqui no se puede. Reemplaza cada `raise` y corre:

      mix test test/sin_mutacion_test.exs
  """

  def total_pesos(embarques) do
    Enum.reduce(embarques, 0, fn embarque, total ->
      total + embarque.peso_kg
    end)
  end

  def marcar_urgentes(embarques) do
    Enum.map(embarques, fn embarque ->
      Map.put(embarque, :urgente, embarque.distancia_km > 500)
    end)
  end

  def aplicar_descuento(precios, pct) do
    Enum.map(precios, fn precio ->
      precio - Integer.floor_div(precio * pct + 50, 100)
    end)
  end

  def contar_por_tipo(embarques) do
    Enum.reduce(embarques, %{}, fn embarque, conteo ->
      Map.update(conteo, embarque.tipo, 1, &(&1 + 1))
    end)
  end

  def sin_duplicados(ids) do
    {_, resultado} =
      Enum.reduce(ids, {MapSet.new(), []}, fn id, {vistos, resultado} ->
        if MapSet.member?(vistos, id) do
          {vistos, resultado}
        else
          {MapSet.put(vistos, id), [id | resultado]}
        end
      end)

    Enum.reverse(resultado)
  end
end
