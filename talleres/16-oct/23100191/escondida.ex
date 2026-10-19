defmodule Escondida do
  def ordenar_por_peso(embarques), do: Enum.sort_by(embarques, & &1.peso_kg)

  def con_descuento(reglas, pct), do: %{reglas | descuento_pct: pct}

  def registrar(vistos, id), do: vistos ++ [id]

  def con_permiso(embarque, permiso) do
    %{embarque | documentos: %{embarque.documentos | permiso: permiso}}
  end

  def fecha_de_entrega(salida, dias), do: Date.add(salida, dias)
end
