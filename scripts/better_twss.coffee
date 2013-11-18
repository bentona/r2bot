twss = require 'twss'

module.exports = (robot) ->
	robot.hear /(.*)/, (msg) ->
		if twss.is(msg.match[1])
			msg.send("That is what she said!")