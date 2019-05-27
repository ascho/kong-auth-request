local http = require "resty.http"
local cjson = require "cjson.safe"

local _M = {}

function _M.execute(conf)
    local ok, err
    local scheme, host, port, _ = unpack(http:parse_uri(conf.auth_uri))

    local client = http.new()
    client:set_timeout(conf.timeout)
    client:connect(host, port)
    if scheme == "https" then
        local ok, err = client:ssl_handshake()
        if not ok then
            kong.log.err(err)
            return kong.response.exit(500, { message = "An unexpected error occurred" })
        end
    end

    local auth_request = _M.new_auth_request(conf.auth_uri, conf.origin_request_headers_to_forward_to_auth)

    local res, err = client:request(auth_request)

    if not res then
        kong.log.err(err)
        return kong.response.exit(500, { message = "An unexpected error occurred" })
    end

    local content = res:read_body()

    local ok, err = client:set_keepalive(conf.keepalive)
    if not ok then
        kong.log.err(err)
        return kong.response.exit(500, { message = "An unexpected error occurred" })
    end

    if res.status > 299 then
        return kong.response.exit(res.status, content)
    end

    for _, name in ipairs(conf.auth_response_headers_to_forward) do
        if res.headers[name] then
            kong.service.request.set_header(name, res.headers[name])
        end
    end
end

function _M.new_auth_request(auth_uri, origin_request_headers_to_forward_to_auth)
    local _, host, _, path = unpack(http:parse_uri(auth_uri))
    local headers = {
        host = host,
        charset = "utf-8",
        ["content-type"] = "application/json"
    }
    for _, name in ipairs(origin_request_headers_to_forward_to_auth) do
        local header_val = kong.request.get_header(name)
        if header_val then
            headers[name] = header_val
        end
    end
    return {
        method = "GET",
        path = path,
        headers = headers,
        body = ""
    }
end

return _M
