---@meta

---@class buffer_utils
buffer_utils = {}

---Fill a buffer stream with numeric values.
---@param buffer userdata Defold buffer handle
---@param stream_name string|hash stream id
---@param components integer components per element (e.g. 2, 3, 4)
---@param values number[] flat array of stream values
function buffer_utils.fill_stream_floats(buffer, stream_name, components, values) end
