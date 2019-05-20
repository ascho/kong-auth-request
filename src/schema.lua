return {
    no_consumer = true,
    fields = {
        timeout = { default = 10000, type = "number" },
        keepalive = { default = 60000, type = "number" },
        auth_uri = { required = true, type = "string" },
        auth_response_headers_to_forward = { type = "array", default = {}}
    }
}