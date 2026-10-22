defmodule ResumenTest do
  use ExUnit.Case, async: true

  @reglas %{
    tarifa_km: 100,
    cuota_puente: %{comercio_mundial: 200, colombia: 300},
    descuento: %{umbral_kg: 8000, pct: 10, criterio: :a_partir_de},
    recargo: %{general: %{pct: 0, fija: 0}},
    base_recargo: :flete,
    minimo: 1000,
    peso_maximo_kg: 34000
  }

  @embarque %{
    id: "A",
    peso_kg: 1000,
    distancia_km: 20,
    tipo: :general,
    puente: :colombia,
    numero_un: nil,
    permiso: nil
  }

  test "lote vacio conserva ambos puentes en cero" do
    assert Cotizador.resumen([], @reglas) == %{
             cotizados: 0,
             rechazados: [],
             total: 0,
             por_puente: %{comercio_mundial: 0, colombia: 0}
           }
  end

  test "lote rechazado conserva el orden de llegada y los totales en cero" do
    lote = [
      %{@embarque | id: "Z", peso_kg: 0},
      %{@embarque | id: "A", distancia_km: 0},
      %{@embarque | id: "M", tipo: :desconocido}
    ]

    assert Cotizador.resumen(lote, @reglas) == %{
             cotizados: 0,
             rechazados: [
               {"Z", :peso_invalido},
               {"A", :distancia_invalida},
               {"M", :tipo_desconocido}
             ],
             total: 0,
             por_puente: %{comercio_mundial: 0, colombia: 0}
           }
  end

  test "acumula varias cotizaciones del mismo puente y conserva el otro en cero" do
    lote = [@embarque, %{@embarque | id: "B", distancia_km: 1}]

    assert Cotizador.resumen(lote, @reglas) == %{
             cotizados: 2,
             rechazados: [],
             total: 3300,
             por_puente: %{comercio_mundial: 0, colombia: 3300}
           }
  end
end
