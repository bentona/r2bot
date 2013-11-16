Coffer = require('../coffer.coffee').Coffer

#message.user.id

class Fight
	constructor: (robot) ->
		robot.brain.data.fights ?= {}

	newCharacter: (id, name) ->
		hero = Coffer.newHero(name)
		this._saveCharacter(hero, id)
		hero.to_json

	characterSheet: (id) ->
		if (c = this._getCharacter)
			c.to_json
		else
			"You haven't made a character yet!"

	#private
	_getCharacter: (id) ->
		if robot.brain.data.fights.characters[id]
			c = Coffer.heroFromJSON(robot.brain.data.fights.characters[id])
		else
			false

	_saveCharacter: (c, id) ->
		robot.brain.data.fights.characters[id] = c.to_json


module.exports = (robot) ->
	robot.respond /^`(.*)\b(.*)/, (msg) ->
		f = new Fight(robot)
		command = msg.match[1]
		switch command
			when 'c' then msg.send(f.characterSheet(msg.user.id))
			when 'n!' then msg.send(f.newCharacter(msg.user.id,msg.match[2]))
			else
				msg.send("That's not a valid command. Try `h.")
###