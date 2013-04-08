# Description:
# Decides where we should lunch
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# hubot /where(.)*(lunch|eat|food)/i- returns where we should eat
#
# Author:
# bentona

module.exports = (robot) ->
	robot.respond /where.*(lunch|eat|food)/i, (msg) ->
		options = ["Muy Bueno","LJS","Burritoville","China Wok","Zoi's","Subway","Bagger Daves","Penn Station"]
		msg.send "You should eat at" + msg.random(options)
