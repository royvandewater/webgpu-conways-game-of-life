
@group(0) @binding(0) var<storage> grid: array<u8>;

// dimensions is an array of 2 unsigned integers. The first is the width, and the second is the height.
@group(0) @binding(1) var<uniform> dimensions: vec2u;

// Interstage variable for passing data from the vertex shader to the fragment shader
struct VertexShaderOutput {
  @builtin(position) position: vec4f,
  @location(0) color: vec4f,
};

@vertex fn vertexShader(
  @builtin(vertex_index) vertexIndex: u32,
) -> @builtin(position) vec4f {
  let coordinate = vec2f(vertexIndex % dimensions.x, vertexIndex / dimensions.x);
  let minMaxValues = vec4f(0.0, 0.0, float(dimensions.x), float(dimensions.y));
  let vertex = scaleCoordinate(coordinate, minMaxValues);

  let shade = float(grid[vertexIndex]);

  let position = vec4f(vertex, 0.0, 1.0);
  let color = vec4f(shade, shade, shade, 1.0);

  return VertexShaderOutput(position, color);
}

@fragment fn fragmentShader(input: VertexShaderOutput) -> @location(0) vec4f {
  return input.color;
}

// moves the coordinate to a -1 to 1 range, adjust for the camera's position and zoom
fn scaleCoordinate(coordinate: vec2f, minMaxValues: vec4f) -> vec2f {
  // First normalize the coordinate to 0-1 range
  let normalizedCoord = ((coordinate - minMaxValues.xy) / (minMaxValues.zw - minMaxValues.xy));

  // Convert to clip space (-1 to 1 range)
  return normalizedCoord * 2.0 - 1.0;
}
