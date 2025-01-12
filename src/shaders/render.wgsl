
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

  // It seems to be important that the index is an int because float indexing into the array
  // appears to interpolate between the values.
  let index = x + (y * u32(gridDimensions.x));
  let color = f32(grid[index]);

  return vec4f(color, color, color, 1.0);
}
