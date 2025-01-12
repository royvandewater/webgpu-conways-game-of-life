
@group(0) @binding(0) var<storage> vertices: array<vec2f>; // a plain quad covering the entire screen
// screenDimensions is an array of 2 unsigned integers. The first is the width, and the second is the height, in pixels
@group(0) @binding(1) var<uniform> screenDimensions: vec2f;
// gridDimensions is an array of 2 unsigned integers. The first is the width, and the second is the height in cells.
@group(0) @binding(2) var<uniform> gridDimensions: vec2f;
@group(0) @binding(3) var<storage> grid: array<u32>;

@vertex fn vertexShader(@builtin(vertex_index) index: u32) -> @builtin(position) vec4f {
  return vec4f(vertices[index], 0.0, 1.0);
}

@fragment fn fragmentShader(@builtin(position) position: vec4f) -> @location(0) vec4f {
  // position is the coordinates of the pixel, in 0 to screen width in pixels
  // we need to convert this to a normalized coordinate, in 0 to 1 range
  let x = u32(gridDimensions.x * position.x / screenDimensions.x);
  let y = u32(gridDimensions.y * position.y / screenDimensions.y);

  let index = x + (y * u32(gridDimensions.x));
  let color = f32(grid[index]);

  return vec4f(color, color, color, 1.0);
}

// // moves the coordinate to a -1 to 1 range, adjust for the camera's position and zoom
// fn scaleCoordinate(coordinate: vec2f, minMaxValues: vec4f) -> vec2f {
//   // First normalize the coordinate to 0-1 range
//   let normalizedCoord = ((coordinate - minMaxValues.xy) / (minMaxValues.zw - minMaxValues.xy));

//   // Convert to clip space (-1 to 1 range)
//   return normalizedCoord * 2.0 - 1.0;
// }
