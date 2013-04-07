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
  randomQuote: -> @cache[Math.floor(Math.random() * @cache.length)]

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

  robot.hear /arrested development/i, (msg) ->
    msg.send adQuotes.randomQuote()
