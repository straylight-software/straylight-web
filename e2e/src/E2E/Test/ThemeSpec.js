// FFI for ThemeSpec.purs

export const extractString = (value) => {
  if (value === null || value === undefined) {
    return "";
  }
  return String(value);
};
