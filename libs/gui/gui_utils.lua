local M = {}


local TEXT_NODE_METRICS = {
    tracking = 1,
    line_break = false,
    width = 0
}

local function is_text_node(node)
    return gui.get_type(node) == gui.TYPE_TEXT
end

local function get_text_node_size(node)
    local font = gui.get_font(node)
    local text = gui.get_text(node)

    TEXT_NODE_METRICS.tracking = gui.get_tracking(node)
    TEXT_NODE_METRICS.line_break = gui.get_line_break(node)
    TEXT_NODE_METRICS.width = gui.get_size(node).x

    local metrics = resource.get_text_metrics(gui.get_font_resource(font), text, TEXT_NODE_METRICS)

    return metrics.width
end

M.get_text_node_size_width_scaled = function (node)
    local font = gui.get_font(node)
    local text = gui.get_text(node)
    local scale = gui.get_scale(node)

    TEXT_NODE_METRICS.tracking = gui.get_tracking(node)
    TEXT_NODE_METRICS.line_break = gui.get_line_break(node)
    TEXT_NODE_METRICS.width = gui.get_size(node).x

    local metrics = resource.get_text_metrics(gui.get_font_resource(font), text, TEXT_NODE_METRICS)

    return metrics.width * scale.x
end

function M.set_nodes_to_center(l_node, r_node, delta)
    delta = delta or 0
    local l_size_x = (is_text_node(l_node) and get_text_node_size(l_node) or gui.get_size(l_node).x) * gui.get_scale(l_node).x
    local r_size_x = (is_text_node(r_node) and get_text_node_size(r_node) or gui.get_size(r_node).x) * gui.get_scale(r_node).x
    local l_pivot = gui.get_pivot(l_node)
    local r_pivot = gui.get_pivot(r_node)
    local l_pos = gui.get_position(l_node)
    local r_pos = gui.get_position(r_node)

    local text_length = l_size_x + r_size_x + delta
    local l_dx = (text_length / 2) - l_size_x
    local r_dx = (text_length / 2) - r_size_x

    l_pos.x = -l_dx
    if l_pivot == gui.PIVOT_W or l_pivot == gui.PIVOT_NW or l_pivot == gui.PIVOT_SW then
        l_pos.x = l_pos.x - l_size_x
    elseif l_pivot == gui.PIVOT_CENTER then
        l_pos.x = l_pos.x - l_size_x / 2
    end
    r_pos.x = r_dx
    if r_pivot == gui.PIVOT_E or r_pivot == gui.PIVOT_NE or r_pivot == gui.PIVOT_SE then
        r_pos.x = r_pos.x + r_size_x
    elseif r_pivot == gui.PIVOT_CENTER then
        r_pos.x = r_pos.x + r_size_x / 2
    end

    gui.set_position(l_node, l_pos)
    gui.set_position(r_node, r_pos)
    return text_length, l_pos, r_pos, l_size_x, r_size_x
end

return M
