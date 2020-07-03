local skynet = require "skynet"
require "skynet.manager"
local sc = require "skynet.socketchannel"

local channel = sc.channel {  --创建一个 channel 对象出来，其中 host 可以是 ip 地址或者域名，port 是端口号。
  host = "127.0.0.1",
  port = 8888,
}

skynet.error("获取的端口 ", channel.__port)

--接收响应的数据必须这么定义，sock就是与远端的TCP服务相连的套接字,通过这个套接字可以把数据读出来
function response(sock)    
--返回值必须要有两个，第一个如果是true表示响应数据是有效的,
    return true, sock:read()   
end

local function task()
    local resp
    local i = 0
    while(i < 3) do
        --第一参数是需要发送的请求，第二个参数是一个函数，用来接收响应的数据。
        --调用channel:request会自动连接指定的TCP服务，并且发送请求消息。
        --该函数阻塞，返回读到的内容。
        resp = channel:request("data"..i.."\n", response)  
        skynet.error("recv", resp)
        i = i + 1
    end
    --channel:close()   --channel可以不用关闭，当前服务退出的时候会自动关闭掉
    skynet.exit()
end

skynet.start(function()
    skynet.fork(task)
end)