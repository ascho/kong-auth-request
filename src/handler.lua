local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.kong-auth-request.access"

local AuthRequestHandler = BasePlugin:extend()

AuthRequestHandler.PRIORITY = 900

function AuthRequestHandler:new()
  AuthRequestHandler.super.new(self, "kong-auth-request")
end

function AuthRequestHandler:access(conf)
  AuthRequestHandler.super.access(self)
  access.execute(conf)
end

return AuthRequestHandler