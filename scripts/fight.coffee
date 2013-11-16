Coffer = require('../coffer.coffee').Coffer

#message.user.id

class Fight
	constructor: (@robot) ->
		@robot.brain.data.fights ?= {}
		@robot.brain.data.fights.characters ?= {}

	reset: () ->
		@robot.brain.data.fights = {}
		@robot.brain.data.fights.characters = {}

	newCharacter: (id, name) ->
		hero = Coffer.newHero(name)
		console.log(hero)
		this._saveCharacter(hero, id)
		return "Character created!: #{hero.characterSheet()}"
		
	characterSheet: (id) ->
		if (hero = this._getCharacter(id))
			hero.characterSheet()
		else
			"You haven't made a character yet!"

	heal: (id) ->
		if (hero = this._getCharacter(id))
			hero.heal()
			this._saveCharacter(hero, id)
			return "Healed! (heart)"
		else
			return "You haven't made a character yet!"

	smoke: (id) ->
		if (hero = this._getCharacter(id))
			if hero.getHigh()
				return "Man you so high!"
			else
				return "You ain't go no drugs man!"
		else
			return "You're so high that you don't exist. (Make a character)."


	adventure: (id) ->
		if (hero = this._getCharacter(id))
			results = Coffer.adventure(hero)
			if results
				this._saveCharacter(hero, id)
				return results
			else
				return "You can't adventure right now."
		else
			return "You haven't made a character yet!"

	#private
	_getCharacter: (id) ->
		if @robot.brain.data.fights.characters[id]
			c = Coffer.heroFromJSON(@robot.brain.data.fights.characters[id])
		else
			false

	_saveCharacter: (c, id) ->
		to_save = c.serialize()
		console.log "saving!"
		console.log to_save
		@robot.brain.data.fights.characters[id] = c.serialize()


module.exports = (robot) ->
	robot.hear /^:([a-z]*)/, (msg) ->
		f = new Fight(robot)
		console.log msg.message.user
		command = msg.match[1]
		switch command
			when 'c' then msg.send(f.characterSheet(msg.message.user.id))
			when 'new' then msg.send(f.newCharacter(msg.message.user.id, msg.message.user.name))
			when 'reset' then msg.send(f.reset())
			when 'a' then msg.send(f.adventure(msg.message.user.id))
			when 'h' then msg.send(f.heal(msg.message.user.id))
			when 'smoke' then msg.send(f.smoke(msg.message.user.id))
			else
				msg.send "commands: :c(haracter sheet), :new (character), :a(dventure), :h(eal)"
###