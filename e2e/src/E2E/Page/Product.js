// FFI for Product.purs
export const indexOf = (needle) => (haystack) => {
  const idx = haystack.indexOf(needle);
  return idx === -1 ? null : idx;
};
