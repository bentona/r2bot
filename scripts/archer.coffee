# Description:
#   Make hubot fetch Archer quotes.
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
  archerQuotes = new WikiQuotes 'Archer_(TV_series)', robot

  robot.hear /^loggin/i, (msg) ->
    msg.reply "call Kenny Loggins, 'cuz you're in the DANGER ZONE."

  robot.hear /^sitting down/i, (msg) ->
    msg.reply "What?! At the table? Look, he thinks he's people!"

  robot.hear /re black/i, (msg) ->
    msg.reply "Oh, are they? Or are five in a dark black, and are five in a slightly darker black?"

  robot.hear /sorry/i, (msg) ->
    msg.reply "Apology accepted. Ass douche."

  robot.hear /(karate|judo|kung[ -]?fu|ta[ei] ?kw[ao]n ?do)/i, (msg) ->
    msg.reply "#{msg.match[1].toString()[0].toUpperCase()}#{msg.match[1].toString()[1..-1]}?! The Dane Cook of martial arts?! No. ISIS agents use Krav Maga."

  robot.hear /(cupcakes|cake|bagels|pie|candy|treats) in t(he|eh) breakroom/i, (msg) ->
    msg.reply "Oh, for heaven's sake... do you want ants? Because that's how you get ants!"

  robot.hear /archer/i, (msg) ->
    msg.reply archerQuotes.randomQuote()

  robot.hear /love/i, (msg) ->
    msg.reply "And I love that I have an erection... that doesn't involve homeless people."
