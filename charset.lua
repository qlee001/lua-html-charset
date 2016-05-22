local str_lower = string.lower
local str_match = string.match
local resp_headers = ngx.resp.get_headers
local re_match = ngx.re.match


local function get_charset_from_header()
    local header = resp_headers()
    local content_type = header["Content-Type"]
    if not content_type then
        return nil
    end

    local res, err = re_match(content_type, '[\\w/]+;\\s*charset=(\\S+)')
    if res then
        local charset = str_lower(res[1])
        return charset
    end

    return nil
end

local function get_charset_from_html(html)
    if type(html) ~= "string" then
        return nil
    end

    local res = re_match(html, '<meta charset="([^\\s]+)"', 'ios')
    if not res then
        res = re_match(html, '<meta\\s+http-equiv="Content-Type"\\s+content="[\\w/]+;\\s*charset=[\\s]*([^\\s"]+)"', 'ios')
    end

    if res then
        local charset = str_lower(res[1])
        return charset
    end

    return nil
end


--Without Nginx_lua api
local function get_charset_from_html2(html)
    if type(html) ~= "string" then
        return nil
    end

    local res = str_match(html, '<meta charset="([^%s"]+)"')
    if not res then
        res = str_match(html, '<meta%s+http%-equiv="Content%-Type"%s+content="[%w/]+;%s*charset=[%s]*([^%s"]+)"')
    end

    if res then
        local charset = str_lower(res)
        return charset
    end

    return nil
end

local _M = { get_charset_from_header = get_charset_from_header,
             get_charset_from_html = get_charset_from_html,
             get_charset_from_html2 = get_charset_from_html2,
           }
return _M
