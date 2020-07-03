local skynet = require "skynet"
require "skynet.manager"
local sc = require "skynet.socketchannel"

local this = {}

local channel = nil
-- 
function this.reponse(skt)
    return true, skt:read()
end

function this.task()
    local i = 3
    while i>0 do
        skynet.error("发送", i)
        local resp = channel:request("channel 请求", this.reponse)
        skynet.error("服务端收到回应", resp)
        i = i -1
    end
    skynet.exit()
end

skynet.start(function ()
    skynet.timeout(100, function ()
        channel = sc.channel{
            host = "127.0.0.1",
            port = "8888",
        } -- socketchannel对象
        skynet.error(channel.__host)
        skynet.fork(this.task)
    end)

    -- skynet.timeout(200, function ()
    --     skynet.error("启动客户端")
    --     skynet.newservice("lynclient")
    -- end)
end)