# Description:
#   Dude where's my car
#
# Commands:
#   and then - no and then
module.exports = (robot) ->

	robot.hear /and then/i, (msg) ->
		msg.send "No and then!"

	robot.hear /dude/i, (msg) ->
		msg.send "Sweet, what about mine?"

	robot.hear /sweet/i, (msg) ->
		msg.send "Dude, what does mine say?"
