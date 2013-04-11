WikiQuotes = require '../wikiquotes'

module.exports = (robot) ->
  idiotQuotes = new WikiQuotes 'Idiocracy', robot
  
  robot.respond /idiots\s*(.*)/i, (msg) ->
    quote = idiotQuotes.randomQuote(msg.match[1])
    msg.send quote if quote
