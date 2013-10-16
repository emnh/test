url = "http://www.reddit.com/r/nsfw.json?after&limit=50&t=all&jsonp=?"

a = (html, href) -> $("<a/>", { html: html, href: href })
img = (title, src) ->  $("<img/>", { title: title, src: src })
li = (x) -> $("<li/>", { html: x })
ul = (list) ->
  d = $("<ul/>")
  li.appendTo(d) for li in list
  d

format = () ->
  pic = $('.pic')
  
  fitWidth = () ->
    parentWidth = $(this).parent().width()
    myWidth = $(this).width()
    console.log(parentWidth)
    newWidth = Math.min(parentWidth, myWidth)
    $(this).width(newWidth)
    
  pic.each(fitWidth)
  pic.error(() -> $(this).hide())

show = (data) ->
  images = data.data.children
  console.log(x.data.url for x in images)
  
  #fixurl = x -> x + ".jpg" # TODO only if imgurl broken
  image = (x) -> img(x.data.title, x.data.url)
  # link = (x) -> a(x.full_name, x.html_url)
  images = ul(li(image(x).attr("class", "pic")) for x in images)
  console.log(images.html())
  images.appendTo('body')
  format()
  
$.getJSON(url, show)
