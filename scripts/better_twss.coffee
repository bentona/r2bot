
twss = require 'twss'

module.exports = (robot) ->
	robot.hear '/*/i' (msg) ->
		if twss.is(msg)
			msg.send("That is what she said!")
