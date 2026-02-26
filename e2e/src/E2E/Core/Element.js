// FFI for Element.purs

export const isNull = (value) => value === null || value === undefined;

// Note: extractNullable needs to match PureScript Maybe constructors
// This is imported from the compiled Data.Maybe output
export const extractNullable = (value) => {
  if (value === null || value === undefined) {
    // Return PureScript Nothing - need to match the exact structure
    return { __tag: "Nothing" };
  }
  // Return PureScript Just
  return { __tag: "Just", value0: value };
};
