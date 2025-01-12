
@group(0) @binding(0) var<storage> vertices: array<vec2f>; // a plain quad covering the entire screen
// dimensions is an array of 2 unsigned integers. The first is the width, and the second is the height.
// @group(0) @binding(1) var<uniform> dimensions: vec2u;
// @group(0) @binding(2) var<storage> grid: array<u8>;

@vertex fn vertexShader(@builtin(vertex_index) index: u32) -> @builtin(position) vec4f {
  return vec4f(vertices[index], 0.0, 1.0);
}

@fragment fn fragmentShader() -> @location(0) vec4f {
  return vec4f(1.0, 0.0, 0.0, 1.0); // start with red
}

// // moves the coordinate to a -1 to 1 range, adjust for the camera's position and zoom
// fn scaleCoordinate(coordinate: vec2f, minMaxValues: vec4f) -> vec2f {
//   // First normalize the coordinate to 0-1 range
//   let normalizedCoord = ((coordinate - minMaxValues.xy) / (minMaxValues.zw - minMaxValues.xy));

//   // Convert to clip space (-1 to 1 range)
//   return normalizedCoord * 2.0 - 1.0;
// }
