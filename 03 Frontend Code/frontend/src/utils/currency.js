const randFormatter = new Intl.NumberFormat("en-ZA", {
  style: "currency",
  currency: "ZAR",
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
});

export function formatRandFromCents(cents = 0) {
  return randFormatter
    .format(Number(cents) / 100)
    .replace(/\u00a0/g, "");
}
