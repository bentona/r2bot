# Description:
#   Anytime somebody says /who wants to/i, say "In the ass?"

module.exports = (robot) ->
	robot.hear /who wants to/i, (msg) ->
		msg.reply "In the ass?"

