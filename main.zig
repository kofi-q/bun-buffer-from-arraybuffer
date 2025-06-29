const t = @import("tokota");

pub const tokota_options = t.Options{
    .napi_version = .v10,
};

comptime {
    t.exportModule(@This());
}

/// Equivalent to:
/// ```c
/// node_api_create_buffer_from_arraybuffer(env, array_buffer, 2, 4, &out)
/// ```
pub fn bufferFromArrayBuffer(array_buffer: t.ArrayBuffer) !t.Buffer {
    return array_buffer.buffer(2, 4);
}
