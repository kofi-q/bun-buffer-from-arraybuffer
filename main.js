// `zig build node` - pass
// `zig build bun` - error

const { Buffer } = require("node:buffer");
const assert = require("node:assert");
const addon = require("./addon.node");

const arrayBuffer = new ArrayBuffer(8);

// JS equivalent works:
const buffer = Buffer.from(arrayBuffer, 2, 4);
assert.strictEqual(buffer.buffer, arrayBuffer);

// But not napi version:
const napi_buffer = addon.bufferFromArrayBuffer(arrayBuffer);
assert.strictEqual(napi_buffer.buffer, arrayBuffer);

console.log("✅");
