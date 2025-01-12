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
  const grid = Uint8Array.from(jsGrid.flat());
  const width = jsGrid[0].length;
  const height = jsGrid.length;

  render({ canvas, device, grid, width, height });
}

await main();
