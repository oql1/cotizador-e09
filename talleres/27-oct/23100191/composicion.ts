// Taller 5 · Composición o herencia
// Cada extra transforma el monto y la cotización aplica los extras en orden.

export type Ajuste = (monto: number) => number;

const pct = (monto: number, p: number): number => Math.floor((monto * p + 50) / 100);

export const frio: Ajuste = (monto) => monto + pct(monto, 18);

export const seguro: Ajuste = (monto) => monto + pct(monto, 2);

export const express: Ajuste = (monto) => monto + 50000;

export function cotizar(km: number, tarifaKm: number, ajustes: readonly Ajuste[]): number {
  return ajustes.reduce((monto, ajuste) => ajuste(monto), km * tarifaKm);
}
