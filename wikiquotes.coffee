# Description:
#   Class for scraping quotes from WikiQuote.org.
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
#   based on archer.coffee by rrix
#   refactored, generalized, robot.brain storage added: jbratton

scraper = require 'scraper'

class WikiQuotes
  constructor: (@wikiquotePath, @robot) ->
    @wikiquotesURI = "http://en.wikiquote.org/wiki/#{@wikiquotePath}"
    @wikiquotesUserAgent = "#{@wikiquotePath}bot for Hubot (+https://github.com/github/hubot-scripts)"
    @brainName = "wikiquotes/#{@wikiquotePath}"
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

module.exports = WikiQuotes
