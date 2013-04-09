# Description:
#   Make hubot fetch Arrested Development quotes.
#
# Dependencies:
#   "scraper": "0.0.9"
#
# Configuration:
#   None
#
# Commands:
#   hubot AD me [regexp] - random AD quote from quotes filtered by the optional regexp string
#
# Author:
#   original archer.coffee: rrix
#   refactored, generalized, robot.brain storage added: jbratton

WikiQuotes = require '../wikiquotes'

module.exports = (robot) ->
  adQuotes = new WikiQuotes 'Arrested_Development_(TV_series)', robot

  robot.respond /AD me\s*(.*)/i, (msg) ->
    quote = adQuotes.randomQuote(new RegExp(msg.match[1], 'i'))
    msg.send quote if quote

  robot.hear /trick/i, (msg) ->
    msg.send "Illusion, #{msg.envelope?.user?.name or 'Michael'}. A trick is something a whore does for money. ...or candy!"

  robot.hear /(morning|weekend|evening|night)/i, (msg) ->
    if Math.random() < .1
      msg.send "Steve Holt!"

  robot.hear /(money|cash)/i, (msg) ->
    if Math.random() < .2
    	msg.send 'How much clearer can I say it: "THERE IS ALWAYS MONEY IN THE BANANA STAND!"'

  robot.hear /(maybe|maeby)/i, (msg) ->
    if Math.random() < .1
      msg.send adQuotes.randomQuote(/maeby/i)

  robot.hear /(george michael|gob|buster|lindsay|tobias|bluth|oscar|wayne|lucille)/i, (msg) ->
    msg.send adQuotes.randomQuote(new RegExp(msg.match[1], 'i'))
