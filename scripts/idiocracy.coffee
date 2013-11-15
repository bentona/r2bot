WikiQuotes = require '../wikiquotes'

module.exports = (robot) ->
  idiotQuotes = new WikiQuotes 'Idiocracy', robot
  
  robot.respond /idiots\s*(.*)/i, (msg) ->
    quote = idiotQuotes.randomQuote(msg.match[1])
    msg.send quote if quote

  robot.hear /(coffee|starbucks)/i, (msg) ->
    if Math.random() < .2
      msg.send "Yeah, well, I really don't think we have time for a hand job, Joe."
