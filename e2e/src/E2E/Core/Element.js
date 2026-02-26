// FFI for Element.purs
export const extractNullable = (value) => {
  if (value === null || value === undefined) {
    return null; // PureScript Nothing
  }
  return value; // PureScript Just
};
