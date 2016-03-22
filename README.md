# lua-html-charset
get charset from html in lua

## how to use
  
### get_charset_from_header 
  get charset info from HTTP header. (only available in nginx lua)
  
### get_charset_from_html
  get charset info from HTML file, argument must be a sting.(only available in nginx lua)

### get_charset_from_html2
  get charset info from HTML file, argument must be a string.

##sample (nginx configure)
        body_filter_by_lua_block {
            if not ngx.ctx.first then
                ngx.ctx.first = 1
            else
                return
            end

            local cs = require "charset"
            local charset = cs.get_charset_from_header()
            if not charset then
                charset = cs.get_charset_from_html(ngx.arg[1])
            end

            if charset then
                ngx.log(ngx.INFO, "page charset:", charset)
            else
                ngx.log(ngx.INFO, "get charset failed")
            end
        }
        
        
