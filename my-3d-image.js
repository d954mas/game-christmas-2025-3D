const VECTOR_NAME = "swag";

// Fragment shader
const fragmentShader = `
    precision highp float;
    uniform sampler2D img;
    uniform sampler2D depth;
    uniform vec2 ${VECTOR_NAME};
    varying vec2 vpos;
    void main() {
        vec4 depthDistortion = texture2D(depth, vpos);
        float parallaxMult = depthDistortion.r;
        vec2 parallax = ${VECTOR_NAME} * parallaxMult;
        vec4 original = texture2D(img, vpos + parallax);
        gl_FragColor = original;
    }
`;

// Vertex shader
const vertexShader = `
    attribute vec2 pos;
    varying vec2 vpos;
    uniform vec2 u_resolution;
    uniform vec2 u_image_resolution;
    uniform vec2 textureScale;
	uniform vec2 ${VECTOR_NAME};
    void main() {
        // Scale the texture coordinates
        vec2 scaledPos = pos* textureScale;

        // Center the position
        vpos = ((pos + 1.0) * 0.5);
		vpos.y = 1.0-vpos.y;

		// Apply mouse offset for parallax effect to gl_Position
        vec2 position = scaledPos + ${VECTOR_NAME} * 2.5; // Adjust the factor for more or less movement
        gl_Position = vec4(position, 0.0, 1.0);
    }
`;

class Image3D {
  constructor(canvas, imageUrl, depthUrl) {
    if (!(canvas instanceof HTMLCanvasElement)) {
      throw new Error("The first argument must be a canvas element.");
    }

    this.canvas = canvas;
    this.imageUrl = imageUrl;
    this.depthUrl = depthUrl;

    this.mouseMoveListener = this.onMouseMove.bind(this);

    this.setup();
  }

  async loadImage(src) {
    const img = new Image();
    img.crossOrigin = "anonymous";
    img.src = src;
    await new Promise((r) => (img.onload = r));
    return img;
  }

  async setup() {
    const img = await this.loadImage(this.imageUrl);
    const depthImg = await this.loadImage(this.depthUrl);

    this.imageWidth = img.width;
    this.imageHeight = img.height;

    this.gl = this.canvas.getContext("webgl");
    if (!this.gl) {
      console.error("WebGL not supported, falling back on experimental-webgl");
      this.gl = this.canvas.getContext("experimental-webgl");
    }
    if (!this.gl) {
      throw new Error("Your browser does not support WebGL");
    }

    const buffer = this.gl.createBuffer();
    this.gl.bindBuffer(this.gl.ARRAY_BUFFER, buffer);
    this.gl.bufferData(
      this.gl.ARRAY_BUFFER,
      new Float32Array([-1, -1, -1, 1, 1, -1, 1, 1]),
      this.gl.STATIC_DRAW
    );
    this.gl.vertexAttribPointer(0, 2, this.gl.FLOAT, false, 0, 0);
    this.gl.enableVertexAttribArray(0);

    const vs = this.gl.createShader(this.gl.VERTEX_SHADER);
    this.gl.shaderSource(vs, vertexShader);
    this.gl.compileShader(vs);
    if (!this.gl.getShaderParameter(vs, this.gl.COMPILE_STATUS)) {
      console.error("An error occurred compiling the vertex shader: ", this.gl.getShaderInfoLog(vs));
      this.gl.deleteShader(vs);
      return;
    }

    const fs = this.gl.createShader(this.gl.FRAGMENT_SHADER);
    this.gl.shaderSource(fs, fragmentShader);
    this.gl.compileShader(fs);
    if (!this.gl.getShaderParameter(fs, this.gl.COMPILE_STATUS)) {
      console.error("An error occurred compiling the fragment shader: ", this.gl.getShaderInfoLog(fs));
      this.gl.deleteShader(fs);
      return;
    }

    this.program = this.gl.createProgram();
    this.gl.attachShader(this.program, vs);
    this.gl.attachShader(this.program, fs);
    this.gl.linkProgram(this.program);
    if (!this.gl.getProgramParameter(this.program, this.gl.LINK_STATUS)) {
      console.error("Unable to initialize the shader program: ", this.gl.getProgramInfoLog(this.program));
      return;
    }
    this.gl.useProgram(this.program);

    this.setTexture(img, "img", 0, this.gl.RGB);
    this.setTexture(depthImg, "depth", 1, this.gl.LUMINANCE);

    this.uResolution = this.gl.getUniformLocation(this.program, "u_resolution");
    this.uImageResolution = this.gl.getUniformLocation(this.program, "u_image_resolution");
    this.textureScale = this.gl.getUniformLocation(this.program, "textureScale");

    const location = this.gl.getUniformLocation(this.program, VECTOR_NAME);
    window.addEventListener('mousemove', this.mouseMoveListener);

    this.resize(this.canvas.clientWidth, this.canvas.clientHeight);
  }

  onMouseMove(e) {
    const mousePosition = getRelativeMousePosition(e);
    this.gl.uniform2fv(this.gl.getUniformLocation(this.program, VECTOR_NAME), new Float32Array(mousePosition));
    requestAnimationFrame(() => this.paint());
  }


  setTexture(image, name, num, format) {
    const texture = this.gl.createTexture();
    this.gl.activeTexture(this.gl.TEXTURE0 + num);
    this.gl.bindTexture(this.gl.TEXTURE_2D, texture);

    this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.LINEAR);
    this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_S, this.gl.CLAMP_TO_EDGE);
    this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_T, this.gl.CLAMP_TO_EDGE);

    this.gl.texImage2D(
      this.gl.TEXTURE_2D,
      0,
      format,
      format,
      this.gl.UNSIGNED_BYTE,
      image
    );
    this.gl.uniform1i(this.gl.getUniformLocation(this.program, name), num);
  }

  paint() {
    if (!this.gl) {
      //console.error("WebGL context is not available.");
      return;
    }
    this.gl.clearColor(0, 0.65, 1, 1);
    this.gl.clear(this.gl.COLOR_BUFFER_BIT);
    this.gl.drawArrays(this.gl.TRIANGLE_STRIP, 0, 4);
  }

  resize(width, height) {
    this.canvas.width = width;
    this.canvas.height = height;
    if (!this.gl) {
     // console.error("WebGL context is not available.");
      return;
    }
    this.gl.viewport(0, 0, this.canvas.width, this.canvas.height);

    const aspectImage = this.imageWidth / this.imageHeight;
    const aspectCanvas = width / height;
    let textureScale;
    if (aspectCanvas > aspectImage) {
      textureScale = [1.0, aspectCanvas/aspectImage];
    } else {
      textureScale = [aspectImage / aspectCanvas, 1.0];
    }

	// Add a slight scale to avoid borders
    const scaleFactor = 1.05; // Adjust the scale factor as needed
    textureScale = textureScale.map(scale => scale * scaleFactor);

    this.gl.uniform2f(this.uResolution, width, height);
    this.gl.uniform2f(this.uImageResolution, this.imageWidth, this.imageHeight);
    this.gl.uniform2fv(this.textureScale, textureScale);

    this.paint();
  }

  delete() {
    if (!this.gl) {
      console.error("WebGL context is not available.");
      return;
    }
    // Remove the mousemove event listener
    window.removeEventListener('mousemove', this.mouseMoveListener);

    // Delete shaders, program, and buffer
    this.gl.deleteProgram(this.program);
    const shaders = this.gl.getAttachedShaders(this.program);
    shaders.forEach(shader => this.gl.deleteShader(shader));

    // Clear textures
    const numTextures = 2; // Adjust if you have more textures
    for (let i = 0; i < numTextures; i++) {
      this.gl.activeTexture(this.gl.TEXTURE0 + i);
      const texture = this.gl.getParameter(this.gl.TEXTURE_BINDING_2D);
      if (texture) {
        this.gl.deleteTexture(texture);
      }
    }

    // Clear buffer
    const buffer = this.gl.getParameter(this.gl.ARRAY_BUFFER_BINDING);
    if (buffer) {
      this.gl.deleteBuffer(buffer);
    }

    // Remove canvas from DOM
    if (this.canvas.parentNode) {
      this.canvas.parentNode.removeChild(this.canvas);
    }

    // Clear WebGL context
    this.gl = null;
  }
}

// Utility function to get relative mouse position
function getRelativeMousePosition(event) {
  const width = window.innerWidth;
  const height = window.innerHeight;
  const pX = -0.5 + event.clientX / width;
  const pY = 0.5 - event.clientY / height;
  return [pX * 0.035, pY * 0.035];
}

// Expose Image3D to the global scope
window.Image3D = Image3D;
