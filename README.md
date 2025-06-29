### Issue:

`node_api_create_buffer_from_arraybuffer` creates a new backing `ArrayBuffer`, with copied data, instead of using the original.

### Repro:

Requires Zig >=0.14.0
- Addon source in [./main.zig](./main.zig)
- JS test in [./main.js](./main.js):

```js
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
```

```console
❯ node -v
v24.2.0

❯ zig build node
✅

❯ bun -v
1.2.17

❯ zig build bun
11 | const buffer = Buffer.from(arrayBuffer, 2, 4);
12 | assert.strictEqual(buffer.buffer, arrayBuffer);
13 |
14 | // But not napi version:
15 | const napi_buffer = addon.bufferFromArrayBuffer(arrayBuffer);
16 | assert.strictEqual(napi_buffer.buffer, arrayBuffer);
            ^
AssertionError: Expected "actual" to be reference-equal to "expected":
+ actual - expected

  ArrayBuffer {
+   [Uint8Contents]: <00 00 00 00>,
+   byteLength: 4
-   [Uint8Contents]: <00 00 00 00 00 00 00 00>,
-   byteLength: 8
  }

 generatedMessage: true,
     actual: ArrayBuffer(4) [ 0, 0, 0, 0 ],
   expected: ArrayBuffer(8) [ 0, 0, 0, 0, 0, 0, 0, 0 ],
   operator: "strictEqual",
       code: "ERR_ASSERTION"

Bun v1.2.17 (macOS arm64)
```
