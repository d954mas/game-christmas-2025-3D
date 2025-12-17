local LOG = require "libs.log"
local TAG = "Firebase"
local M = {
    inited = false
}

function M:init()
    if firebase then
        local firebase_analytics_callback = function (_, message_id, message)
            LOG.i("firebase analytics callback:" .. message_id, TAG)
            pprint(message)
            if message_id == firebase.analytics.MSG_ERROR then
                -- an error was detected when performing an analytics config operation
                LOG.i("Firebase Analytics Config error: ".. message.error, TAG)
                return
            end

            if message_id == firebase.analytics.MSG_INSTANCE_ID then
                -- result of the firebase.analytics.get_id() call
                LOG.i("Firebase Analytics Config instance_id: " .. message.instance_id, TAG)
                return
            end
        end

        firebase.set_callback(function (_, message_id, message)
            --LOG.i("firebase:", message_id)
            -- pLOG.i(message)
            if message_id == firebase.MSG_INITIALIZED then
                LOG.i("firebase initialized", TAG)
                firebase.analytics.set_callback(firebase_analytics_callback)
                M.inited = true
                firebase.analytics.initialize()
            elseif message_id == firebase.MSG_INSTALLATION_ID then
                LOG.i("id:" .. message.id, TAG)
            elseif message_id == firebase.MSG_INSTALLATION_AUTH_TOKEN then
                LOG.i("token:" .. message.token, TAG)
            elseif message_id == firebase.MSG_ERROR then
                LOG.i("ERROR:" .. message.error, TAG)
            end
        end)
        firebase.initialize()
    end
end

---@param name string
function M:event(name)
    if M.inited then
        firebase.analytics.log(name)
    else
        if firebase and firebase.analytics then
            LOG.w("firebase not inited. event:" .. name, TAG)
        end
    end
end

---@param name string
---@param value_name string
---@param value string
function M:event_string(name, value_name, value)
    if M.inited then
        firebase.analytics.log_string(name, value_name, value)
    else
        LOG.w("firebase not inited. event:" .. name, TAG)
    end
end

---@param name string
---@param value_name string
---@param value number
function M:event_number(name, value_name, value)
    if M.inited then
        firebase.analytics.log_number(name, value_name, value)
    else
        LOG.w("firebase not inited. event:" .. name, TAG)
    end
end

---@param name string
---@param value table
function M:event_table(name, value)
    if M.inited then
        firebase.analytics.log_table(name, value)
    else
        LOG.w("firebase not inited. event:" .. name, TAG)
    end
end

function M:error(message)
    self:event_table("game_error", {
        message = message
    })
end

return M
