export type Puente = "comercio_mundial" | "colombia";

type Carga =
  | { tipo: "general" }
  | { tipo: "refrigerada" }
  | { tipo: "peligrosa"; numeroUn: string }
  | { tipo: "sobredimensionada"; permiso: string };

type Datos = {
  id: string;
  pesoKg: number;
  distanciaKm: number;
  puente: Puente;
};

type Embarque = Datos & Carga;
export type Borrador = {
  estado: "borrador";
  embarque: Embarque;
};

type Cotizacion = {
  id: string;
  fleteBruto: number;
  descuento: number;
  flete: number;
  cuotaPuente: number;
  recargo: number;
  ajusteMinimo: number;
  total: number;
};

export type Cotizado = {
  estado: "cotizado";
  embarque: Embarque;
  cotizacion: Cotizacion;
};

type Motivo = "peso_invalido" | "distancia_invalida" | "excede_peso_maximo";

export type Rechazado = {
  estado: "rechazado";
  embarque: Embarque;
  motivo: Motivo;
};
export type Despachado = {
  estado: "despachado";
  embarque: Embarque;
  cotizacion: Cotizacion;
  folio: string;
};

export type Reglas = {
  tarifaKm: number;
  cuotaPuente: Record<Puente, number>;
  descuento: {
    umbralKg: number;
    pct: number;
    criterio: "a_partir_de" | "mas_de";
  };
  recargo: Record<Carga["tipo"], { pct: number; fija: number }>;
  baseRecargo: "flete" | "subtotal";
  minimo: number;
  pesoMaximoKg: number;
};

type Resultado<T, E> = { ok: true; valor: T } | { ok: false; error: E };

const POLITICAS: Record<Carga["tipo"], { aplicaPesoMaximo: boolean }> = {
  general: { aplicaPesoMaximo: true },
  refrigerada: { aplicaPesoMaximo: true },
  peligrosa: { aplicaPesoMaximo: true },
  sobredimensionada: { aplicaPesoMaximo: false },
};

function validar(
  embarque: Embarque,
  reglas: Reglas,
): Resultado<Embarque, Motivo> {
  if (embarque.pesoKg <= 0) {
    return { ok: false, error: "peso_invalido" };
  }

  if (embarque.distanciaKm <= 0) {
    return { ok: false, error: "distancia_invalida" };
  }

  const politica = POLITICAS[embarque.tipo];

  if (politica.aplicaPesoMaximo && embarque.pesoKg > reglas.pesoMaximoKg) {
    return { ok: false, error: "excede_peso_maximo" };
  }

  return { ok: true, valor: embarque };
}

function pct(monto: number, porcentaje: number): number {
  return Math.floor((monto * porcentaje + 50) / 100);
}

function calcularDescuento(
  fleteBruto: number,
  pesoKg: number,
  descuento: Reglas["descuento"],
): number {
  const cumpleUmbral =
    descuento.criterio === "a_partir_de"
      ? pesoKg >= descuento.umbralKg
      : pesoKg > descuento.umbralKg;

  return cumpleUmbral ? pct(fleteBruto, descuento.pct) : 0;
}

function calcular(embarque: Embarque, reglas: Reglas): Cotizacion {
  const fleteBruto = embarque.distanciaKm * reglas.tarifaKm;

  const descuento = calcularDescuento(
    fleteBruto,
    embarque.pesoKg,
    reglas.descuento,
  );

  const flete = fleteBruto - descuento;
  const cuotaPuente = reglas.cuotaPuente[embarque.puente];

  const reglaRecargo = reglas.recargo[embarque.tipo];
  const base =
    reglas.baseRecargo === "flete"
      ? flete
      : flete + cuotaPuente;

  const recargo = pct(base, reglaRecargo.pct) + reglaRecargo.fija;
  const subtotal = flete + cuotaPuente + recargo;
  const total = Math.max(subtotal, reglas.minimo);

  return {
    id: embarque.id,
    fleteBruto,
    descuento,
    flete,
    cuotaPuente,
    recargo,
    ajusteMinimo: total - subtotal,
    total,
  };
}

export function cotizar(b: Borrador, r: Reglas): Cotizado | Rechazado {
  const resultado = validar(b.embarque, r);

  if (!resultado.ok) {
    return {
      estado: "rechazado",
      embarque: b.embarque,
      motivo: resultado.error,
    };
  }

  return {
    estado: "cotizado",
    embarque: resultado.valor,
    cotizacion: calcular(resultado.valor, r),
  };
}

export function despachar(_c: Cotizado, _folio: string): Despachado {
  throw new Error("por implementar");
}
