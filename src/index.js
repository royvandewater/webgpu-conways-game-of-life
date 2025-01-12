import { assert } from "./assert.js";
import { render } from "./render.js";

async function main() {
  assert(
    globalThis.navigator,
    "window.navigator is not defined, WebGPU is not supported"
  );

  const adapter = await navigator.gpu.requestAdapter();
  const device = await adapter.requestDevice();
  const canvas = document.querySelector("canvas");

  const jsGrid = [
    [0, 1],
    [1, 0],
  ];
  // kinda dumb we gotta use a 32bit array to store a boolean value. WGSL supports array<bool>,
  // but there isn't an equivalent in JS that we can use to transfer it. Maybe we'll experiment with
  // binpacking at some point, but not now.
  const grid = Uint32Array.from(jsGrid.flat());
  const width = jsGrid[0].length;
  const height = jsGrid.length;

  render({ canvas, device, grid, width, height });
}

await main();
