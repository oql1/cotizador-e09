defmodule Cotizador do
  @tipos [:general, :refrigerada, :peligrosa, :sobredimensionada]

  def cotizar(embarque, reglas) do
    with :ok <- validar(embarque, reglas) do
      {:ok, calcular(embarque, reglas)}
    end
  end

  defp validar(%{peso_kg: p}, _reglas) when p <= 0, do: {:error, :peso_invalido}

  defp validar(%{distancia_km: d}, _reglas) when d <= 0, do: {:error, :distancia_invalida}

  defp validar(%{tipo: t}, _reglas) when t not in @tipos, do: {:error, :tipo_desconocido}

  defp validar(%{puente: puente}, %{cuota_puente: cuotas})
       when not is_map_key(cuotas, puente),
       do: {:error, :puente_desconocido}

  defp validar(%{tipo: :peligrosa, numero_un: nil}, _reglas), do: {:error, :falta_numero_un}

  defp validar(%{tipo: :sobredimensionada, permiso: nil}, _reglas), do: {:error, :falta_permiso}

  defp validar(%{tipo: :sobredimensionada}, _reglas), do: :ok

  defp validar(%{peso_kg: p}, %{peso_maximo_kg: maximo}) when p > maximo,
    do: {:error, :excede_peso_maximo}

  defp validar(_embarque, _reglas), do: :ok

  defp calcular(embarque, reglas) do
    flete_bruto = embarque.distancia_km * reglas.tarifa_km
    descuento = descuento(flete_bruto, embarque.peso_kg, reglas.descuento)
    flete = flete_bruto - descuento
    cuota_puente = Map.fetch!(reglas.cuota_puente, embarque.puente)

    %{
      id: embarque.id,
      flete_bruto: flete_bruto,
      descuento: descuento,
      flete: flete,
      cuota_puente: cuota_puente,
      recargo: 0,
      ajuste_minimo: 0,
      total: flete + cuota_puente
    }
  end

  defp descuento(flete_bruto, peso_kg, %{
         criterio: :a_partir_de,
         umbral_kg: umbral,
         pct: porcentaje
       })
       when peso_kg >= umbral,
       do: pct(flete_bruto, porcentaje)

  defp descuento(flete_bruto, peso_kg, %{criterio: :mas_de, umbral_kg: umbral, pct: porcentaje})
       when peso_kg > umbral,
       do: pct(flete_bruto, porcentaje)

  defp descuento(_flete_bruto, _peso_kg, _reglas_descuento), do: 0

  defp pct(monto, porcentaje), do: div(monto * porcentaje + 50, 100)
end
