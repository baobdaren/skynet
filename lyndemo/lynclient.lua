-- 用skynet模拟一个简单的客服端

local skynet = require "skynet"
local socket = require "skynet.socket"

local this = {}

skynet.start(function ()
    local socketid = socket.open("127.0.0.1", 8888)
    skynet.error("sockeid  =", socketid)
    assert(socketid)
    skynet.error("开启客户端ing--")
    skynet.fork(this.netRead, socketid)
end)

function this.netRead(socketid)
    while true do
        socket.write(socketid, "我是skynet模拟客户端")
        local str = socket.readline(socketid)
        skynet.error("客户端接收：",str)
        if str == "exit" then
            skynet.error("退出")
            break
        end
    end
    socket.close(socketid)
    skynet.exit()
end