import { autoResize } from "./autoResize.js";
import { resolveShader } from "./resolveShader.js";

/**
 * @param {{canvas: HTMLCanvasElement, device: GPUDevice, grid: Uint8Array, width: number, height: number}} options
 */
export const render = async ({ canvas, device, grid, width, height }) => {
  const context = canvas.getContext("webgpu");
  const presentationFormat = navigator.gpu.getPreferredCanvasFormat();

  context.configure({
    device,
    format: presentationFormat,
  });

  autoResize(canvas, device);

  const module = device.createShaderModule({
    label: "render module",
    code: await resolveShader("src/shaders/render.wgsl"),
  });

  const pipeline = device.createRenderPipeline({
    label: "render pipeline",
    layout: "auto",
    vertex: {
      entryPoint: "vertexShader", // Converts grid coordinates to screen coordinates
      module,
    },
    fragment: {
      entryPoint: "fragmentShader",
      module,
      targets: [{ format: presentationFormat }],
    },
    primitive: {
      topology: "triangle-strip",
    },
  });

  const vertices = new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]);
  const verticesBuffer = device.createBuffer({
    label: "vertices buffer",
    size: vertices.byteLength,
    usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
  });
  device.queue.writeBuffer(verticesBuffer, 0, vertices);

  // const gridBuffer = device.createBuffer({
  //   label: "grid buffer",
  //   size: grid.byteLength,
  //   usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
  // });
  // device.queue.writeBuffer(gridBuffer, 0, grid);

  // const dimensions = Uint32Array.from([width, height]);
  // const dimensionsBuffer = device.createBuffer({
  //   label: "dimensions buffer",
  //   size: dimensions.byteLength,
  //   usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
  // });
  // device.queue.writeBuffer(dimensionsBuffer, 0, dimensions);

  const bindGroup = device.createBindGroup({
    label: "render bind group",
    layout: pipeline.getBindGroupLayout(0),
    entries: [
      { binding: 0, resource: { buffer: verticesBuffer } },
      // { binding: 1, resource: { buffer: dimensionsBuffer } },
      // { binding: 2, resource: { buffer: gridBuffer } },
    ],
  });

  const renderPassDescriptor = {
    label: "our basic canvas render pass",
    colorAttachments: [
      {
        clearValue: [1.0, 1.0, 1.0, 1.0],
        loadOp: "clear",
        storeOp: "store",
      },
    ],
  };

  const renderLoop = () => {
    // make a command encoder to start encoding commands
    const encoder = device.createCommandEncoder({
      label: "out render encoder",
    });

    // Get the current texture from the canvas context and
    // set it as the texture to render to.
    renderPassDescriptor.colorAttachments[0].view = context
      .getCurrentTexture()
      .createView();
    const renderPass = encoder.beginRenderPass(renderPassDescriptor);
    renderPass.setPipeline(pipeline);
    renderPass.setBindGroup(0, bindGroup);
    renderPass.draw(width * height);
    renderPass.end();

    device.queue.submit([encoder.finish()]);

    requestAnimationFrame(renderLoop);
  };

  renderLoop();
};
