WikiQuotes = require '../wikiquotes'

module.exports = (robot) ->
  idiotQuotes = new WikiQuotes 'Idiocracy', robot
  
  robot.respond /idiots\s*(.*)/i, (msg) ->
    quote = idiotQuotes.randomQuote(msg.match[1])
    msg.send quote if quote

  robot.hear /money/i, (msg) ->
    msg.send "I can't believe you like money too. We should hang out."
