module.exports = (robot) ->
	robot.respond /inspect me/i, (msg) ->
		msg.send console.log(msg)
