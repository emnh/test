// see also:
// https://github.com/kanaka/clojurescript
// http://kanaka.github.io/clojurescript/web/jsrepl.html

// http://jsbin.com/UcayUD/53/edit"

function hilight(code, fn)
{
  var syntaxService = "http://pygments-emh.herokuapp.com/pyg";

  //$.post(syntaxService
  
  $.ajax({
    url: syntaxService,
    type: "POST",
    crossDomain: true,
    data: { 
      lang: 'clojure',
      code: code
      //stamp: new Date().getTime()
    },
    success: fn,
    dataType: "text",
    cache: false
  });
}

//'http://pygments.appspot.com/'), {'lang'=>lang, 'code'=>code})

var expr = $('.cljs').text();

$('.clojure').html("waiting for syntax highlight..");
$('.code').html("wating for compile..");
$('.result').html("wating for evaluation..");

hilight(expr, function(data) {  $('.clojure').html(data); });

console.log(expr);

function getCompiled(data) {
  $('.code').html(data);
  var result = cljs.reader.read_string(data);
  //console.log(result);
  result = (new cljs.core.Keyword("\uFDD0:js")).call(null, result);
  //console.log(result);
  result = eval(result);
  var pr = cljs.core.pr_str.call(null, result);
  $('.result').html(pr);
}

if (expr !== undefined)
{
  /* 
  var compileURL = "http://himera-emh.herokuapp.com/compile-jsonp";
  $.ajax({
    type: "GET",
    url: compileURL + "?expr=" + encodeURIComponent(expr),
    //data: "expr=" + data,
    success: getCompiled,
    crossDomain: true,
    dataType: "jsonp",
    //jsonp: true,
    jsonpCallback: "getCompiled"
  }); */
  var compileURL = "http://himera-emh.herokuapp.com/compile";
  $.ajax({
    type: "POST",
    url: compileURL,
    //contentType: "application/clojure; charset=utf-8",
    contentType: "application/clojure",
    data: "{ :expr " + expr + " }",
    success: getCompiled,
    crossDomain: true,
    dataType: "text",
    cache: false
  });
}
