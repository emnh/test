boter = require("boter")
fs = require("fs")
CoffeeScript = require('coffee-script')
watch = require('node-watch')
opts = channels: ["#lart-test"]
bot = new boter.Bot("irc.homelien.no", "emh_bot", opts)

mkLoadFile = (logmsg) ->
  loadFile = (err, data) ->
    if err
      msg = "Error loading plugin: #{err}"
      logmsg msg
    else
      try
        result = CoffeeScript.compile(data)
        eval(result)
        logmsg "Loaded #{url} successfully"
      catch error
        logmsg = "Error loading plugin: #{error}"

loadPlugin = (message) ->
  url = message.text
  console.log "Loading plugin #{url}"
  loadFile = mkLoadFile (msg) ->
    console.log msg
    message.reply msg
  fs.readFile(url, {encoding: "utf-8"}, loadFile)
  
loadPluginPlugin =
  commands:
    load: loadPlugin

bot.load("loader"; loadPluginPlugin)

watch "bot",
  recursive: false
  followSymLinks: true
, (filename) ->
  if !///irc.coffee///.test(filename) and ///\.coffee$///.test(filename)
    loadFile = mkLoadFile (msg) -> console.log(msg)
    console.log filename, " changed, reloading plugin"
    fs.readFile(filename, {encoding: "utf-8"}, loadFile)
    return

goodMorning = (message) ->
  console.log(message)
  message.reply "Good morning to you, too, " + message.from.nickname + "!"  if /^good morning/.test(message.text)
  return

goodMorningPlugin =
  events:
    highlight: goodMorning
    mention: goodMorning
  commands:
    hello: goodMorning
    greet: goodMorning

bot.load("morning"; goodMorningPlugin)
