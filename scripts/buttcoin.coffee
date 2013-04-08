# Description:
#   Current buttcoin price.
#
# Commands:
#   hubot butt me - shows current buttcoin price from MtGox.

module.exports = (robot) ->

  robot.respond /butt me/i, (msg) ->
    msg.http('http://data.mtgox.com/api/2/BTCUSD/money/ticker')
      .get() (err, res, body) ->
        gox = JSON.parse(body)
        msg.send "Current buttcoin (BTC) price: #{gox.data.last_local.display}"
