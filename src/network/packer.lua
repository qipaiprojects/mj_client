-- 网络消息封包解包
local Utils = require "utils"
local msg_define = require "network.msg_define"

local M = {}

-- 包格式
-- 两字节包长
-- 两字节协议号
-- 两字符字符串长度
-- 字符串内容
function M.pack(proto_name, msg)
	local proto_id = msg_define.name_2_id(proto_name)
    local params_str = Utils.table_2_str(msg)
	print("msg content:", params_str)
	local len = 2 + 2 + #params_str
	local data = Utils.int16_2_bytes(len) .. Utils.int16_2_bytes(proto_id) .. Utils.int16_2_bytes(#params_str) .. params_str
    return data	
end

function M.unpack(data)
	print("数据包长",#data)
	local proto_id = data:byte(1) * 256 + data:byte(2)
	local params_str = data:sub(3+2)
	print(proto_id, params_str)
	local proto_name = msg_define.id_2_name(proto_id)
	local params = Utils.str_2_table(params_str)
    return proto_name, params	
end

return M
