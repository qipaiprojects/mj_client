local M = {}

local id_tbl = {
    -- 登陆协议
    {name = "login.login"},
    {name = "login.register"},
    -- baseapp登陆
    {name = "login.login_baseapp"},
    {name = "room.create_room"},
    {name = "room.join_room"},
    {name = "room.room_begin"},
    {name = "match.dealt"},
}

local name_tbl = {}

for id,v in ipairs(id_tbl) do
    name_tbl[v.name] = id
end

function M.name_2_id(name)
    return name_tbl[name]
end

function M.id_2_name(id)
    local v = id_tbl[id]
    if not v then
        return
    end

    return v.name
end

function M.get_by_id(id)
    return id_tbl[id]
end

function M.get_by_name(name)
    local id = name_tbl[name]
    return id_tbl[id]
end

return M
