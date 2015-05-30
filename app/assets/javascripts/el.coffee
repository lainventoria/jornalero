typeIsArray = Array.isArray || ( value ) -> return

toAttrs = (obj) ->
    $.map obj, (value, key) ->
        return "#{key}='#{value}'"
    .join(" ")

build_method = (v) ->
  (args, content='') ->
    args ||= {}
    if (k for own k of args).length
        attrs = " " + toAttrs(args)
    else
        attrs = ''
    if typeIsArray content
        content = content.join ' '
    if content is ''
        "<#{v}#{attrs}/>"
    else
        "<#{v}#{attrs}>#{content}</#{v}>"

$.extend
    el: {}

for func in ["div", "span", "ul", "li", "form", "input", "textarea", "select",
"button", "img", "hr", "table", "thead", "tbody", "tfoot", "th", "tr", "td",
"a", "b", "i", "u", "strike", "strong", "p", "br", "h1", "h2", "h3", "h4",
"h5", "h6", "pre", "code", "script" ]
    (a = {})[func] = build_method(func)
    $.extend $.el, a

