local CLASS = require "libs.class"
local LUME = require "libs.lume"

local TABLE_INSERT = table.insert
local TABLE_REMOVE = table.remove
local MATH_MAX = math.max


---@class Entity
---@field _in_world boolean|nil

local ECS = {}

--region Filter

--- Filter functions.
-- A Filter is a function that selects which Entities apply to a System.
--
-- Filters must be added to Systems by setting the `filter` field of the System.
-- Filter's returned by tiny-ecs's Filter functions are immutable and can be
-- used by multiple Systems.

--- Makes a Filter from a string. Syntax of `pattern` is as follows.
--
--   * Tokens are alphanumeric strings including underscores.
--   * Tokens can be separated by |, &, or surrounded by parentheses.
--   * Tokens can be prefixed with !, and are then inverted.
--
-- Examples are best:
--    'a|b|c' - Matches entities with an 'a' OR 'b' OR 'c'.
--    'a&!b&c' - Matches entities with an 'a' AND NOT 'b' AND 'c'.
--    'a|(b&c&d)|e - Matches 'a' OR ('b' AND 'c' AND 'd') OR 'e'


local function buildPart(str)
    local accum = {}
    local subParts = {}
    str = str:gsub('%b()', function (p)
        subParts[#subParts + 1] = buildPart(p:sub(2, -2))
        return ('\255%d'):format(#subParts)
    end)
    for invert, part, sep in str:gmatch('(%!?)([^%|%&%!]+)([%|%&]?)') do
        if part:match('^\255%d+$') then
            local partIndex = tonumber(part:match(part:sub(2)))
            accum[#accum + 1] = ('%s(%s)')
                :format(invert == '' and '' or 'not', subParts[partIndex])
        else
            accum[#accum + 1] = ("(e.%s %s nil)")
                :format(part, invert == '' and '~=' or '==')
        end
        if sep ~= '' then
            accum[#accum + 1] = (sep == '|' and ' or ' or ' and ')
        end
    end
    return table.concat(accum)
end

---@alias EcsFilter function(entity) endregion

---@return EcsFilter
function ECS.filter(pattern)
    local source = ("return function(e) return %s end"):format(buildPart(pattern))
    local loader, err = loadstring(source)
    if not loader or err then error(err) end
    return loader()
end

--endregion

--region Utils

local function add_entity_to_list(e, entity_list, entity_map)
    assert(not entity_map[e])
    local index = #entity_list + 1
    entity_list[index] = e
    entity_map[e] = index
end

local function remove_entity_from_list(e, entity_list, entity_map)
    local e_index = assert(entity_map[e])
    local last_entity = entity_list[#entity_list]
    local last_entity_index = entity_map[last_entity]

    entity_map[last_entity] = e_index
    entity_list[e_index] = last_entity

    entity_list[last_entity_index] = nil
    entity_map[e] = nil
end

--endregion

---@class EcsSystem
---@field filter EcsFilter
---@field world EcsWorld|nil
---@field on_add function
---@field on_remove function
---@field on_add_to_world function
---@field on_remove_from_world function
---@field update function
local System = CLASS.class("System")

function System:initialize()
    self.__time = { current = 0, max = 0, average = 0, average_count = 0, average_value = 0 }
    ---@type Entity[]
    self.entities_list = {}
    self.entities = {}
    self.buffered_time = 0 --for interval
end

---@class EcsWorld
local World = CLASS.class("World")

function World:initialize()
    self.frame = 0
    self.odd = false

    self.systems = {}
    self.entities = {}
    ---@type Entity[]
    self.entities_list = {}

    self.entities_to_remove = {}
    self.entities_to_change = {}
    self.systems_to_add = {}
    self.systems_to_remove = {}

    self.systems_with_update = {}
    self.systems_with_draw = {}
end

---@param _ Entity
---@diagnostic disable-next-line: duplicate-set-field
function World:on_entity_added(_) end

---@param _ Entity
---@diagnostic disable-next-line: duplicate-set-field
function World:on_entity_removed(_) end

---@param _ Entity
function World:on_entity_updated(_) end

function World:add_entity(entity)
    local e2c = self.entities_to_change
    e2c[#e2c + 1] = assert(entity)
end

function World:remove_entity(entity)
    assert(entity)
    local e2r = self.entities_to_remove
    e2r[#e2r + 1] = assert(entity)
end

function World:add_system(system)
    assert(system.world == nil, "System already belongs to a World.")
    local s2a = self.systems_to_add
    s2a[#s2a + 1] = system
    system.world = self
    return system
end

function World:remove_system(system)
    assert(system.world == self, "System does not belong to this World.")
    local s2r = self.systems_to_remove
    s2r[#s2r + 1] = system
end

function World:manage_systems()
    local s2a, s2r = self.systems_to_add, self.systems_to_remove

    -- Early exit
    if #s2a == 0 and #s2r == 0 then return end
    local systems = self.systems
    local entities = self.entities
    -- Remove Systems
    for i = 1, #s2r do
        local system = s2r[i]
        local on_remove = system.on_remove
        if on_remove then
            local s_entity_list = system.entities_list
            for j = 1, #s_entity_list do on_remove(system, s_entity_list[j]) end
        end
        if system.update then
            LUME.removei(self.systems_with_update, system)
        end
        if system.draw then
            LUME.removei(self.systems_with_draw, system)
        end
        LUME.removei(systems, system)
        if system.on_remove_from_world then system:on_remove_from_world() end
        s2r[i] = nil

        -- Clean up System
        system.world = nil
        system.entities_list = {}
        system.entities = {}
    end

    -- Add Systems
    for i = 1, #s2a do
        local system = s2a[i]
        TABLE_INSERT(systems, system)
        system.world = self
        if system.on_add_to_world then system:on_add_to_world() end

        if system.update then
            TABLE_INSERT(self.systems_with_update, system)
        end
        if system.draw then
            TABLE_INSERT(self.systems_with_draw, system)
        end

        -- Try to add Entities
        local filter = system.filter
        if filter then
            local s_entity_list = system.entities_list
            local s_entities = system.entities
            local on_add = system.on_add
            for j = 1, #entities do
                local entity = entities[j]
                if filter(entity) then
                    add_entity_to_list(entity, s_entity_list, s_entities)
                    if on_add then on_add(system, entity) end
                end
            end
        end
        s2a[i] = nil
    end
end

function World:manage_entities()
    local e2r = self.entities_to_remove
    local e2c = self.entities_to_change

    -- Early exit
    if #e2r == 0 and #e2c == 0 then return end

    local entities = self.entities
    local entities_list = self.entities_list
    local systems = self.systems

    -- Remove Entities
    for i = #e2r, 1, -1 do
        local entity = TABLE_REMOVE(e2r, i)
        if entities[entity] then
            self:on_entity_removed(entity)
            entity._in_world = false
            remove_entity_from_list(entity, entities_list, entities)
            -- Remove from cached systems
            for j = 1, #systems do
                local system = systems[j]
                local s_entities = system.entities
                local s_entities_list = system.entities_list
                if s_entities[entity] then
                    remove_entity_from_list(entity, s_entities_list, s_entities)
                    if system.on_remove then system:on_remove(entity) end
                end
            end
        end
    end

    -- Change Entities
    for i = #e2c, 1, -1 do
        local entity = TABLE_REMOVE(e2c, i)
        if not entity._in_world then
            entity._in_world = true
            add_entity_to_list(entity, entities_list, entities)
            self:on_entity_added(entity)
        else
            self:on_entity_updated(entity)
        end
        for j = 1, #systems do
            local system = systems[j]
            local s_entities = system.entities
            local s_entities_list = system.entities_list
            local filter = system.filter
            if filter then
                if filter(entity) then
                    if not s_entities[entity] then
                        add_entity_to_list(entity, s_entities_list, s_entities)
                        if system.on_add then system:on_add(entity) end
                    end
                else
                    if s_entities[entity] then
                        remove_entity_from_list(entity, s_entities_list, s_entities)
                        if system.on_remove then system:on_remove(entity) end
                    end
                end
            end
        end
        e2c[i] = nil
    end
end

function World:draw(dt)
    --#IF DEBUG
    if profiler then profiler.scope_begin("ECS world draw") end
    --#ENDIF

    local systems = self.systems_with_draw

    --  Iterate through Systems IN ORDER
    for i = 1, #systems do
        local system = systems[i]
        -- Update Systems that have an draw method
        local draw = system.draw
        --#IF DEBUG
        if profiler then profiler.scope_begin(system.__class.name) end
        --#ENDIF
        local start_time = chronos.nanotime()
        draw(system, dt)
        --#IF DEBUG
        system.__time.current = chronos.nanotime() - start_time
        system.__time.max = MATH_MAX(system.__time.max, system.__time.current)
        --average bad. For 0,0,0,0,0,1 average will be 0.5
        system.__time.average = system.__time.average + system.__time.current
        system.__time.average_count = system.__time.average_count + 1
        if system.__time.average_count > 1800 then
            --update once a minute
            system.__time.average_value = system.__time.average
            system.__time.average = 0
            system.__time.average_count = 0
        end
        if profiler then profiler.scope_end() end
        --#ENDIF
    end
    --#IF DEBUG
    if profiler then profiler.scope_end() end
    --#ENDIF
end

--- Updates the World by dt (delta time).
function World:update(dt)
    --#IF DEBUG
    if profiler then profiler.scope_begin("ECS world update") end
    --#ENDIF

    self:manage_systems()
    self:manage_entities()

    local systems = self.systems_with_update
    self.frame = self.frame + 1
    self.odd = self.frame % 2 == 0

    --  Iterate through Systems IN ORDER
    for i = 1, #systems do
        local system = systems[i]
        -- Update Systems that have an update method (most Systems)
        local update = system.update
        --#IF DEBUG
        if profiler then profiler.scope_begin(system.__class.name) end
        --#ENDIF
        local start_time = chronos.nanotime()
        local interval = system.interval
        if interval then
            local buffered_time = system.buffered_time + dt
            while buffered_time >= interval do
                buffered_time = buffered_time - interval
                update(system, dt)
            end
            system.buffered_time = buffered_time
        elseif (system.odd) then
            if (self.odd) then
                update(system, dt)
            end
        elseif (system.even) then
            if (not self.odd) then
                update(system, dt)
            end
        else
            update(system, dt)
        end
        --#IF DEBUG
        system.__time.current = chronos.nanotime() - start_time
        system.__time.max = MATH_MAX(system.__time.max, system.__time.current)
        --average bad. For 0,0,0,0,0,1 average will be 0.5
        system.__time.average = system.__time.average + system.__time.current
        system.__time.average_count = system.__time.average_count + 1
        if system.__time.average_count > 1800 then
            --update once a minute
            system.__time.average_value = system.__time.average
            system.__time.average = 0
            system.__time.average_count = 0
        end
        if profiler then profiler.scope_end() end
        --#ENDIF
    end
    --#IF DEBUG
    if profiler then profiler.scope_end() end
    --#ENDIF
end

function World:clear_entities()
    for i = 1, #self.entities_list do
        self:remove_entity(self.entities_list[i])
    end
end

function World:clear_systems()
    for i = #self.systems, 1, -1 do
        self:remove_system(self.systems[i])
    end
end

function World:refresh()
    self:manage_systems()
    self:manage_entities()
end

function World:clear()
    self:clear_entities()
    self:clear_systems()
    self:refresh()
end

function ECS.world() return CLASS.new_instance(World) end

ECS.System = System


return ECS
