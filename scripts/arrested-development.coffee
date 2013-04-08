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
#
# Author:
#   original archer.coffee: rrix
#   refactored, generalized, robot.brain storage added: jbratton

WikiQuotes = require '../wikiquotes'

module.exports = (robot) ->
  adQuotes = new WikiQuotes 'Arrested_Development_(TV_series)', robot

  robot.hear /trick/i, (msg) ->
    msg.send "Illusion, #{msg.user?.name or 'Michael'}. A trick is something a whore does for money. ...or candy!"

  robot.hear /(morning|weekend|evening|night)/i, (msg) ->
    if Math.random() < .1
      msg.send "Steve Holt!"

  robot.hear /(money|cash)/i, (msg) ->
    if Math.random() < .25
    	msg.send 'How much clearer can I say it: "THERE IS ALWAYS MONEY IN THE BANANA STAND!"'

  robot.hear /(maybe|maeby)/i, (msg) ->
    if Math.random() < .15
      msg.send adQuotes.randomQuote(/maeby/i)

  robot.hear /(arrested|development|george|michael|gob|buster|bluth|banana|lucille)/i, (msg) ->
    msg.send adQuotes.randomQuote()
