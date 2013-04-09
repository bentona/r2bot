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


class Lunching
	constructor: (@robot) ->
		@cache = []
		@robot.brain.on 'loaded', =>
			if @robot.brain.data.lunching
				@cache = @robot.brain.data.lunching
	add: (place) ->
		if !(place in @cache)
			@cache.push place
			@robot.brain.data.lunching = @cache
	all: -> (@cache || "I don't know")
	deleteByPattern: (pattern) ->
		@cache = @cache.filter (n) -> !(new RegExp(pattern,'i').test(n))
		@robot.brain.data.lunching = @cache
	deleteAll: () ->
		@cache = []
		@robot.brain.data.lunching = @cache

module.exports = (robot) ->
	lunching = new Lunching robot
	robot.respond /(where|what).*(lunch|eat|food)/i, (msg) ->
		msg.send ("You should eat at " + msg.random(lunching.all()))
	robot.respond /we should eat at (.*)/i, (msg) ->
		lunching.add(msg.match[1].trim())
		msg.send ("Ok, we'll eat at " + msg.match[1].trim() + " sometime.")
	robot.respond /we should never eat at (.*)/i, (msg) ->
		lunching.deleteByPattern(msg.match[1].trim())
		msg.send("Ok, we'll never eat at " + msg.match[1].trim())
	robot.respond /lunch places/i, (msg) ->
		msg.send lunching.all().reduce ((p1,p2) -> p1 + ', ' + p2),' '
