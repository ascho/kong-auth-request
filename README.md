# kong-auth-request
A Kong plugin that make GET auth request before proxying the original request.

## Description
kong-auth-request is a reincarnation of [ngx http auth request](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html "ngx http auth request").    

Plugin takes GET http request with Authorization header and send it to auth service (url is taken from plugin  configuration), then if auth response status code is 200 then plugin routes original request to upstream service with headers (header names are taken from plugin configuration) from auth response.   
If auth response code is greater than 299 then auth response is returned to client and origin request is not passed to upstream.

## Installation

Install plugin by luarocks package manager.  
```luarocks install kong-auth-request```

Add kong-auth-request to Kong by environment variable
```KONG_PLUGINS=bundled,kong-auth-request```   

or add it to kong.conf:  
```plugins = bundled,kong-auth-request```


## Configuration

```
curl -X POST \
--url "http://localhost:8001/services/fibery-api/plugins" \
--data "name=kong-auth-request" \
--data "config.auth_uri=http://auth.fibery.io/authorize" \
--data "config.auth_response_headers_to_forward[]=x-authorization"
--data "config.origin_request_headers_to_forward_to_auth[]=host"
```

config parameter | description
-----------------|--------------
config.auth_uri  | Plugin make a HTTP GET request with Authorization header to this URL before proxying the original request
config.auth_response_headers_to_forward | If auth request was successful then plugin takes header names from auth_response_headers_to_forward collection, then finds them in auth response headers and adds them into origin request before proxying it to upstream.
config.origin_request_headers_to_forward_to_auth | Origin request headers to pass to auth uri
## Author

Andray Shotkin

## License

The MIT License (MIT)
=====================

Copyright (c) 2019 Andray Shotkin

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
