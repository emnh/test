# Translated from JS to Coffee using js2coffee.org and manual error correction
# Not hooked up to planets.html yet. Planets.js is still being used.

# looks similar to http://glsl.heroku.com/e#9955.0

# `// noprotect `

Planets = {}

init = ->
  # Creates canvas 320 × 200 at 10, 50
  Planets.paper = Raphael(10, 50, 620, 400)

initdraw = ->
  startd = new Date()
  drawstate.startn = startd.getTime()
  drawstate.interval = 10
  drawstate.y = Planets.paper.height / 2
  
initplanets = ->
  drawstate.planets = []
  drawstate.planetcount = 100
  i = undefined
  i = 0
  while i < drawstate.planetcount
    planet =
      x: Math.random()
      y: Math.random()
      xv: 0
      yv: 0

    drawstate.planets[i] = planet
    i++

euclid = (p1, p2) ->
  xd = p2.x - p1.x
  yd = p2.y - p1.y
  ret =
    xd: xd
    yd: yd
    d: Math.sqrt(xd * xd + yd * yd) / 10
  ret

updateplanets = ->
  for i in [0..drawstate.planets.length-1]
    do (i) ->
      xd = 0
      yd = 0
      for j in [0..drawstate.planets.length-1]
        if i != j
          do (i, j) ->
            p1 = drawstate.planets[i]
            p2 = drawstate.planets[j]
            e = euclid(p1, p2)
            e.d = e.d / 1000
            drawstate.planets[i].xv += e.d * e.xd
            drawstate.planets[i].yv += e.d * e.yd
            
  
  i = 0
  for i in [0..drawstate.planets.length-1]
    do (i) ->
      # friction
      drawstate.planets[i].xv = drawstate.planets[i].xv * 0.999
      drawstate.planets[i].yv = drawstate.planets[i].yv * 0.999

      # update positions
      drawstate.planets[i].x += drawstate.planets[i].xv
      drawstate.planets[i].x = drawstate.planets[i].x % 1.0
      drawstate.planets[i].y += drawstate.planets[i].yv
      drawstate.planets[i].y = drawstate.planets[i].y % 1.0  

drawplanets = () ->
  Planets.paper.clear()
  drawstate.y = drawstate.y + 20 * (Math.random() - 0.5)
  drawstate.y = drawstate.y % Planets.paper.height
  circlesize = 10
  i = 0
  for i in [0..drawstate.planets.length-1]
    do (i) ->
      p = drawstate.planets[i]

      # keep within bounds
      x = p.x * (Planets.paper.width - circlesize * 2) + circlesize
      y = p.y * (Planets.paper.height - circlesize * 2) + circlesize
      circle = Planets.paper.circle(x, y, circlesize)
      cb = i * 1579 + Planets.ctime / 10
      circle.attr "fill", "rgb(" + cb % 251 + "," + cb % 255 + "," + cb % 253 + ")"

      #circle.attr("fill", "rgb(200,30,40)");
      circle.attr "stroke", "#fff"

draw = ->
  d = new Date()
  n = d.getTime()
  Planets.ctime = n - drawstate.startn
  ctint = Planets.ctime / drawstate.interval
  
  updateplanets()
  drawplanets()
  #if Planets.maxit > 0
  window.requestAnimationFrame draw

drawstate = {}
init()
initdraw()
initplanets()
window.requestAnimationFrame draw
