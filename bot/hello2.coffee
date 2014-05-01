hoodMorning = (message) ->
  console.log(message)
  message.reply "Food morning to you, too, " + message.from.nickname + "!"  if /^hood morning/.test(message.text)
  return

plugin = () ->
  events:
    highlight: hoodMorning
    mention: hoodMorning

console.log("loading hello2")
name = "hello"
# hack: access bot internals to reload plugin
delete bot.plugins[name]
bot.load(name, plugin)
