makeH = () ->
  html = {}
  tags = ["script", "div", "span", "p", "ul", "li", "a",
          "table", "th", "tr", "td", "colgroup", "col", "thead", "tbody",
          "h1", "h2", "h3", "h4", "h5",
          "label", "input", "button"]
  makeTagDef = (tag) ->
    html[tag] = (content, attrs = {}) ->
      attrs.html = content
      $("<" + tag + "/>", attrs)
  makeTagDef(tag) for tag in tags
  return html

window.HTML = makeH()
