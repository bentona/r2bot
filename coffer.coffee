Cutil = {
	roll: (n) -> Math.floor(Math.random() * n) + 1

	ndice: (n, sides) -> (this.roll(sides) for _ in [1..n]).reduce (x,y) -> x + y

	getRandom: (arr) -> arr[this.roll(arr.length) - 1]

	doesHit: (attacker, defender) ->
		# roll (str)d6 vs (dex)d6
		(Cutil.ndice(attacker.getStr(), 6) > Cutil.ndice(defender.getDex(), 6))
}

class Status
	constructor: (@effect, @message) ->
		# nothin

	affect: (hero) ->
		@effect(hero)

class High extends CofferStatus
	constructor: () ->
		high = (hero) -> hero.effects.dex -= 1
		super(high, "You're like, totally blazed.")

class CofferCreature
	constructor: (@name, @stats, @status = nil) ->
		@stats.hp = @stats.max_hp if not 'hp' of @stats

	getDex: () -> @stats.dex + @effects?.dex?

	getStr: () -> @stats.str + @effects?.str?

	alive: () -> @hp > 0

	heal: (n = this.max_hp) -> 
		@hp = Math.min(@max_hp, @hp + n)
		# TODO: A better status system
		@status = {}

	damage: (n) ->
		@hp = Math.max(0, @hp - n)

	addItems: (items) -> # TODO: This is crappy, we need a separate inventory class.
		for k,v of items
			@inventory[k] = ((@inventory[k] || 0) + v)


class CofferHero extends CofferCreature

	constructor: (name, stats) ->
		super(name, stats)

	@newHero: (name) ->
		stats = {
			str: 3 + Cutil.roll(2)
			dex: 3 + Cutil.roll(2)
			max_hp: 6 + Cutil.roll(3)
		}
		new CofferHero(name, stats)

	@heroFromJSON: (json) ->
		status
		c = new CofferHero(json.name, json.stats)
		c.inventory = json.inventory
		c

	level: () -> Math.ceil(Math.log(@xp + 2,2))

	addXP: (points) -> @xp += points

	inventorySummary: () -> ("#{v}x #{k}" for k,v of @inventory).join("\n")

	statSummary: () -> "str: #{@str}\tdex: #{@dex}\nhp: #{@hp}\tXP: #{@xp}"

	characterSheet: () -> "#{@name}\n#{@statSummary()}\n#{@inventorySummary()}"

	serialize: () -> {
		stats: @stats
		xp: @xp
		inventory: @inventory
		status: this.status
	}

class CofferTreasure
	random: () ->
		loot: [
			'(plus1)',
			'buttcoin',
			'(awww)',
			'moog synthesizer',
			'iPad Air',
			'(mbjb)',
			'(ctddfn)',
			'(benspants)',
			'skeebie blint',
			'purp scurp'
		]
		Cutil.getRandom(loot)

class CofferMonster extends CofferCreature
	@monsterTypes: [
		'eddie',
		'tug',
		'socialist',
		'Internet Explorer',
		'BRT',
		'Cantwell',
		'Mike Howe',
		"ANH ANH ANH ANH"
	]

	@monsterMods: {
		beefy: (monster) ->
			monster.str += Cutil.roll(2)
			monster

		scrawny: (monster) ->
			monster.str = Math.max(monster.str - Cutil.roll(2) , 1)
			monster

		portly: (monster) ->
			monster.hp += Cutil.roll(3)
			monster

		slovenly: (monster) ->
			monster.hp += Cutil.roll(6)
			monster

		devious: (monster) ->
			monster.dex += Cutil.roll(2)
			monster
	}

	@randomMonster: (lvl) ->
		type = Cutil.getRandom(CofferMonster.monsterTypes)
		mod = Cutil.getRandom(Object.keys(CofferMonster.monsterMods))
		name = "#{mod} #{type}"
		stats = {
			str: Cutil.ndice(lvl, 2),
			dex: Cutil.ndice(lvl, 2),
			max_hp: lvl + Cutil.ndice(lvl,3)
		}
		new CofferMonster(name, stats, [mod])

	constructor: (name, stats, mods) ->
		super(name, stats)
		for mod in mods
			mod(@)
		@

class CofferGame
	attack: (a, b) ->
		if (Cutil.roll(10) == 10) || a.doesHit(b)
			damage = Cutil.roll(a.str)
			b.damage(damage)
			return damage
		else
			return false

	turnMessage: (a, b, hit) ->
		if hit
			message = "#{a.name} did #{hit} damage to #{b.name}\n"
		else
			message = "#{a.name} missed #{b.name}\n"
		message += "(boom) #{b.name} is defeated!\n" if !b.alive()
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
			xp: mlvl + Cutil.roll(mlvl)
			items: {}
		}
		for i in [1..mlvl]
			item = Cutil.getRandom(this.loot)
			reward.items[item] = (reward.items[item] || 0) + 1
		reward

	getDefeat: (hero, mlvl) ->
		"(failed) You died cause you suck"

	rewardString: (reward) ->
		itemListing = ("#{quantity}x #{item}" for item,quantity of reward.items).join(', ')
		xpString = "(mindblown) You gained #{reward.xp} XP"
		return "(santa) You gained #{itemListing}\n#{xpString}\n"

	adventure: (hero) ->
		return false if ! hero.alive()
		monster = this.monsterFactory(hero.level)
		mlvl = monster.level
		message = "(ninja) You've encountered a level #{mlvl} #{monster.name}\n"
		details = this.fight(hero, monster)
		if hero.alive()
			reward = this.getReward(hero, mlvl)
			hero.addXP(reward.xp)
			hero.addItems(reward.items)
			message += this.rewardString(reward)
		else
			message += this.getDefeat(hero, mlvl)
		return "#{message}\nDetails:\n#{details}"
}
exports.Coffer = Coffer

