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

scraper = require 'scraper'

class WikiQuotes
  constructor: (@sourceName, @wikiquotePath, @robot) ->
    @wikiquotesURI = "http://en.wikiquote.org/wiki#{@wikiquotePath}"
    @wikiquotesUserAgent = "#{@sourceName}bot for Hubot (+https://github.com/github/hubot-scripts)"
    @brainName = "wikiquotes#{@wikiquotePath}"
    @cache = []
    @scraperOptions = {
      'uri': @wikiquotesURI,
      'headers': {
        'User-Agent': "User-Agent: #{@wikiquotesUserAgent}"
      }
    }
    @robot.brain.on 'loaded', =>
      this.loadQuotes()

  addQuoteArray: (quoteArray) ->
    this.addQuote(quote, false) for quote in quoteArray
    this.storeQuotes()

  addQuote: (quote, saveAfter = true) ->
    @cache.push quote
    this.storeQuotes() if saveAfter

  storeQuotes: ->
    @robot.brain.data[@brainName] = @cache

  loadQuotes: ->
    if quoteData = @robot.brain.data[@brainName]
      @cache = quoteData
    else
      this.scrapeQuotes()

  all: -> @cache
  randomQuote: (filterRegex) ->
    filteredQuotes = if filterRegex then @cache.filter (quote) -> filterRegex.test(quote) else @cache
    filteredQuotes[Math.floor(Math.random() * filteredQuotes.length)]

  # I think the argument to scrapeQuotes is necessary because of scoping;
  # calling this.addQuoteArray did nothing.
  scrapeQuotes: (me = this) ->
    scraper @scraperOptions, (err, jQuery) ->
      throw err if err
      quoteArray = jQuery("dl").toArray()
      cleanedArray = quoteArray.map (quote) -> "#{jQuery(quote).text().trim()}\n"
      me.addQuoteArray(cleanedArray)

module.exports = (robot) ->
  adQuotes = new WikiQuotes 'ArrestedDevelopment', '/Arrested_Development_(TV_series)', robot

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
