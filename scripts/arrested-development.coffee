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
#   adapted to AD: jbratton

scraper = require 'scraper'

module.exports = (robot) ->

  robot.hear /arrested development/i, (msg) ->

    options = {
       'uri': 'http://en.wikiquote.org/wiki/Arrested_Development_(TV_series)',
       'headers': {
         'User-Agent': 'User-Agent: ArrestedDevelopmentbot for Hubot (+https://github.com/github/hubot-scripts)'
       }
    }

    scraper options, (err, jQuery) ->
      throw err  if err
      quotes = jQuery("dl").toArray()
      dialog = ''
      quote = quotes[Math.floor(Math.random()*quotes.length)]
      dialog += jQuery(quote).text().trim() + "\n"
      msg.send dialog
