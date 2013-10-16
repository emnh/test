// looks similar to http://glsl.heroku.com/e#9955.0

function init() {
  // Creates canvas 320 × 200 at 10, 50
  //paper = Raphael(10, 50, 620, 400);
  var w = $(window).width(), 
      h = $(window).height();
  paper = Raphael(10, 50, w - 10, h - 50);
}

function initdraw()
{
  startd = new Date();
  drawstate.startn = startd.getTime();
  drawstate.interval = 10;
  drawstate.y = paper.height / 2;
}

function initplanets()
{
  drawstate.planets = [];
  drawstate.planetcount = 100;
  var i;
  for (i = 0; i < drawstate.planetcount; i++) 
  {
    var planet = {
      x: Math.random(),
      y: Math.random(),
      xv: 0,
      yv: 0
    };
    drawstate.planets[i] = planet;
  }
}

function euclid(p1, p2)
{
  var xd = p2.x - p1.x;
  var yd = p2.y - p1.y;
  var ret = {
    xd: xd,
    yd: yd,
    d: Math.sqrt(xd * xd + yd * yd) / 10
  };
  return ret;
}

function updateplanets()
{
  for (i = 0; i < drawstate.planets.length; i++) 
  {
    var xd = 0;
    var yd = 0;
    for (j = 0; j < drawstate.planets.length; j++) 
    {
      if (i == j) continue;
      var p1 = drawstate.planets[i];
      var p2 = drawstate.planets[j];
      e = euclid(p1, p2);
      e.d = e.d / 1000;
      drawstate.planets[i].xv += e.d * e.xd;
      drawstate.planets[i].yv += e.d * e.yd;
    }
  }
  for (i = 0; i < drawstate.planets.length; i++)
  {
    // friction
    drawstate.planets[i].xv = drawstate.planets[i].xv * 0.999;
    drawstate.planets[i].yv = drawstate.planets[i].yv * 0.999;
    
    // update positions
    drawstate.planets[i].x += drawstate.planets[i].xv;
    drawstate.planets[i].x = drawstate.planets[i].x % 1.0;
    drawstate.planets[i].y += drawstate.planets[i].yv;
    drawstate.planets[i].y = drawstate.planets[i].y % 1.0;
  }
}

function draw() {  
  var d = new Date();
  var n = d.getTime();
  
  var ctime = n - drawstate.startn;
  var ctint = ctime / drawstate.interval;
  //console.log(ctime);
  
  updateplanets();
  
  paper.clear();
  drawstate.y = drawstate.y + 20 * (Math.random() - 0.5);
  drawstate.y = drawstate.y % paper.height;
  
  var i;
  var circle;
  var circlesize = 10;
  for (i = 0; i < drawstate.planets.length; i++) 
  {
    var p = drawstate.planets[i];
    // keep within bounds
    var x = p.x * (paper.width - circlesize * 2) + circlesize;
    var y = p.y * (paper.height - circlesize * 2) + circlesize;
    circle = paper.circle(x, y, circlesize);
    var cb = i * 1579 + ctime / 10;
    circle.attr("fill", "rgb(" + cb % 251 + "," + cb % 255 + "," + cb % 253 + ")");
    //circle.attr("fill", "rgb(200,30,40)");
    circle.attr("stroke", "#fff");
  }
  window.requestAnimationFrame(draw);
}

var paper;
var drawstate = {};

init();
initdraw();
initplanets();
window.requestAnimationFrame(draw);
//setInterval(draw, drawstate.interval);
