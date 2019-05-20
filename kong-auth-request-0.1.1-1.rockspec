package = "kong-auth-request"

version = "0.1.1-1"

-- The version '0.1.1' is the source code version, the trailing '1' is the version of this rockspec.
-- whenever the source version changes, the rockspec should be reset to 1. The rockspec version is only
-- updated (incremented) when this file changes, but the source remains the same.

supported_platforms = {"linux", "macosx"}

source = {
  url = "git://github.com/ascho/kong-auth-request",
  tag = "0.1.1"
}

description = {
  summary = "A Kong plugin that make POST auth request before proxying the original.",
  license = "MIT"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.kong-auth-request.access"] = "src/access.lua",
    ["kong.plugins.kong-auth-request.handler"] = "src/handler.lua",
    ["kong.plugins.kong-auth-request.schema"] = "src/schema.lua"
  }
}
