Coffer = {

	roll: (n) -> Math.floor(Math.random() * n) + 1

	ndice: (n, sides) -> (this.roll(sides) for _ in [1..n]).reduce (x,y) -> x + y

	getRandom: (arr) -> arr[this.roll(arr.length) - 1]

	creature: (name,str,dex,hp) ->
		{
			name: name
			str: str
			dex: dex
			hp: hp
			level: 1
			xp: 0
			inventory: {}

			alive: () -> this.hp > 0

			addXP: (xp) -> this.xp += xp

			addItems: (items) ->
				for k,v of items
					this.inventory[k] = ((this.inventory[k] || 0) + v)
				
			inventorySummary: () -> ("#{v}x #{k}" for k,v of this.inventory).join("\n")

			statSummary: () -> "str: #{this.str}\tdex: #{this.dex}\nhp: #{this.hp}\tXP: #{this.xp}"

			characterSheet: () -> "#{statSummary()}\n#{this.inventorySummary()}"
			
			doesHit: (target) -> (this.ndice(this.str, 6) > this.ndice(target.dex, 6))
		}

	newHero: (name) ->
		this.creature(name, 3, 3, 5)

	loot: [
		'buttcoin',
		'(awww)',
		'moog synthesizer',
		'raspberry pi',
		'MacBook Pro',
		'iPad Air',
		'fiverr',
		'(mbjb)',
		'(ctddfn)',
		'(benspants)',
		'skeebie blint',
		'purp scurp'
	]

	monsterTypes: [
		'eddie',
		'tug',
		'socialist',
		'Internet Explorer'
	]

	monsterMods: {
		beefy: (monster) ->
			monster.str += this.roll(2)
			monster

		scrawny: (monster) ->
			monster.str = Math.max(monster.str - this.roll(2) , 1)
			monster

		portly: (monster) ->
			monster.hp += this.roll(3)
			monster

		slovenly: (monster) ->
			monster.hp += this.roll(6)
			monster

		devious: (monster) ->
			monster.dex += this.roll(2)
			monster
	}

	monsterFactory: (lvl) ->
		type = this.getRandom(this.monsterTypes)
		mod = this.getRandom(Object.keys(this.monsterMods))
		baseMonster = this.creature("#{mod} #{type}", this.ndice(lvl, 2), this.ndice(lvl,2), lvl + this.ndice(lvl,3))
		moddedMonster = this.monsterMods[mod](baseMonster)
		moddedMonster.level = lvl
		moddedMonster

	attack: (a, b) ->
		if (this.roll(10) > 1) || a.doesHit(b)
			damage = this.roll(a.str)
			b.hp -= damage
			return damage
		else
			return false

	turnMessage: (a, b, hit) ->
		if hit
			message = "#{a.name} did #{hit} damage to #{b.name}\n"
		else
			message = "#{a.name} missed #{b.name}\n"
		message += "#{b.name} is defeated!\n" if !b.alive()
		return message

	battleTurn: (a,b) ->
		hit = this.attack(a,b)
		message = this.turnMessage(a, b, hit)
		return message

	battleRound: (a, b) ->
		message = this.battleTurn(a,b)
		if (b.alive() && a.alive())
			message += this.battleTurn(b,a)
		return message

	fight: (a, b) ->
		fightText = ''
		nextRound = true
		while (nextRound)
			nextRound = false
			message = this.battleRound(a,b)
			fightText += message
			if (a.alive() && b.alive())
				nextRound = true
		return fightText

	getReward: (hero, mlvl) ->
		reward = {
			xp: mlvl + this.roll(mlvl)
			items: {}
		}
		for i in [1..mlvl]
			item = this.getRandom(this.loot)
			reward.items[item] = (reward.items[item] || 0) + 1
		reward

	getDefeat: (hero, mlvl) ->
		"You died cause you suck"

	rewardString: (reward) ->
		itemListing = ("#{quantity}x #{item}" for item,quantity of reward.items).join(', ')
		xpString = "You gained #{reward.xp} XP"
		return "You gained #{itemListing}\n#{xpString}\n"

	adventure: (hero) ->
		monster = this.monsterFactory(hero.level)
		mlvl = monster.level
		fightText = this.fight(hero, monster)
		if hero.alive()
			reward = this.getReward(hero, mlvl)
			hero.addXP(reward.xp)
			hero.addItems(reward.items)
			message = this.rewardString(reward)
		else
			message = this.getDefeat(hero, mlvl)
		return [fightText, message]
}
exports.Coffer = Coffer



