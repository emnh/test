code = "
1 + 2
"

options = {
            comment: false
            range: false
            loc: false
            tolerant: false
        }
#result = esprima.parse(code, options);

data = [
          {
          title: "node1"
          folder: true
          children: [{ title: "test" }, { title: "test2" }]
          },
          {
          title: "node2",
          key: 1337,
          folder: true,
          lazy: true
          }
  ]

class PTree

class Eval
  constructor: (inv) ->
    @invocation = inv
  
class Invocation
  constructor: (list) ->
    @list = list
    [@fun, @args...] = list
    @valargs = []
  
  mapf: (f) -> 
    if $.isFunction(f)
      f()
    else
      f
  
  apply: () ->
    istack = []
    istack.push(["root", this])
    ctr = 0
    `// noprotect`
    while istack.length > 0
      ctr += 1
      [parent, i] = istack.pop()
      #console.log("parenti: ")
      #console.log([parent, i])
      if i instanceof Invocation
        mappedargs = (@mapf(arg) for arg in i.args)
        e = new Eval(i)
        istack.push([parent, e])
        istack.push([i, arg]) for arg in mappedargs
        i.children = (arg for arg in mappedargs)
        #if parent != "root"
        #  parent.children = mappedargs
      else if i instanceof Eval
        i = i.invocation
        result = i.fun.apply(i.fun, i.valargs)
        i.result = result
        if result instanceof Invocation
          istack.push([parent, result])
        else
          if istack.length > 0
            parent.valargs.push(result)
      else
        parent.valargs.push(i)
    return result

test = (x) ->
  () ->
  if x > 1
    return () -> test(x - 1)
  else
    return 1

fib = (n) ->
  result =
    if (n < 2)
      1
    else
      i = [((a, b) -> a + b),
           (() -> fib(n - 2)),
           (() -> fib(n - 1))]
      inv = new Invocation(i)
      inv.getTitle = () -> "fib(#{n}) = #{@result}"
      inv
  return result

proctree = (t) ->
  p = new PTree()
  if t instanceof Invocation
    p.title = t.getTitle()
    p.folder = true
    p.children = (proctree(c) for c in t.children)
  else
    p.title = JSON.stringify(t)
  return p

d = (x) -> "console.log({#{x}: JSON.stringify(#{x})})"

class LazyTree
  
  constructor: (inv) ->
    @tkey = 0
    @tmap = {}
    @root = @newNode(inv)
    
  newNode: (inv) ->
    @tkey += 1
    @tmap[@tkey] = new LazyNode(this, inv, @tkey)
    return @tmap[@tkey]
  
  getNode: (key) ->
    node = @tmap[key]
    return node
        
class LazyNode
  
  constructor: (lazytree, t, key) ->
    #eval(d("lazytree"))
    @lazytree = lazytree
    @key = key
    @invocation = t
    if t instanceof Invocation
      @title = t.getTitle() + " TODO: recompute on expand all"
      @getTitle = t.getTitle
      @folder = true
      @lazy = true
    else
      @title = JSON.stringify(t)
      @getTitle = () -> @title
      @result = t
      @recompute = () -> return @result
  
  recompute: () ->
    if @children?
      valargs = (c.result for c in @children when c.result?)
      eval(d("valargs"))
      if valargs.length == @children.length
        @invocation.result = @invocation.fun.apply(@invocation.fun, valargs)
        @result = @invocation.result
    return @result
  
  getChildren: () ->
    t = @invocation
    #eval(d("this"))
    mappedargs = (@invocation.mapf(arg) for arg in @invocation.args)
    @children = (@lazytree.newNode(c) for c in mappedargs)
    return @children

initTree = (inv) ->
  lazytree = new LazyTree(inv)
  
  divtree = $("#lzytree")
  divtree.fancytree({
    filter:
      mode: "hide"
    source:
      [lazytree.root]
    activate:
      (e, data) ->
        $("#json").html(data.node.title)
        node = lazytree.getNode(data.node.key)
        node.recompute()
        data.node.setTitle(node.getTitle())
    lazyload:
      (event, data) ->
        node = lazytree.getNode(data.node.key)
        data.result = node.getChildren()
    })
    
expandbutton = (button, tree) ->
  button.click () ->
    if @value == "Expand All"
      tree.fancytree("getRootNode").visit (node) ->
        node.setExpanded true
      $(@).attr("value", "Collapse All")
    else
      tree.fancytree("getRootNode").visit (node) ->
        node.setExpanded false
      $(@).attr("value", "Expand All")
  
main = () ->
    
  inv = new Invocation([() -> fib(10)])
  result = inv.apply()
  
  initTree(inv.result)
  expandbutton($("#expandall2"), $("#lzytree"))
  
  tree = proctree(inv.result)
  js = JSON.stringify(tree, null, 2)
  #$("#json").html(js)
  
  divtree = $("#treetable")
  expandbutton($("#expandall1"), divtree)
  divtree.fancytree({
    extensions: ["table"]
    table:
      indentation: 20 # indent 20px per node level
      nodeColumnIdx: 2 # render the node title into the 2nd column
      checkboxColumnIdx: 0 # render the checkboxes into the 1st column
    renderColumns: (e, data) ->
      node = data.node
      $tdList = $(node.tr).find(">td")
      # (index #0 is rendered by fancytree by adding the checkbox)
      $tdList.eq(1).text(node.getIndexHier()).addClass "alignRight"
      # (index #2 is rendered by fancytree)
      $tdList.eq(3).text node.key
    filter:
      mode: "hide"
    source:
      [tree]
    lazyload:
      (event, data) ->
        key = data.node.key + 1
        data.result = [
          {title: "A lazy node " + key, key: key, lazy: true},
          {title: "Another node", selected: true}
        ]
        return
    })
  
stack = "https://raw.github.com/eriwen/javascript-stacktrace/master/stacktrace.js"
decycle = "https://raw.github.com/douglascrockford/JSON-js/master/cycle.js"
scripts = [stack, decycle]

# get scripts and run main, equivalent to:
# ..., $.getScript(stack, () -> $.getScript(decycle, main)))
fun = main
while scripts.length > 0
  script = scripts.pop()
  fun = do (script, fun) ->
    () -> $.getScript(script, fun)
fun()
