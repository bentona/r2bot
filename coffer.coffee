Cutil = {
	roll: (n) -> Math.floor(Math.random() * n) + 1

	ndice: (n, sides) -> (this.roll(sides) for _ in [1..n]).reduce (x,y) -> x + y

	getRandom: (arr) -> arr[this.roll(arr.length) - 1]
}

Coffer = {

	creature: (name,str,dex,max_hp) ->
		{
			name: name
			str: str
			dex: dex
			max_hp: max_hp
			hp: max_hp
			level: 1
			xp: 0
			inventory: {}
			high: false

			alive: () -> this.hp > 0

			addXP: (xp) -> this.xp += xp

			addItems: (items) ->
				for k,v of items
					this.inventory[k] = ((this.inventory[k] || 0) + v)
				
			inventorySummary: () -> ("#{v}x #{k}" for k,v of this.inventory).join("\n")

			statSummary: () -> "str: #{this.str}\tdex: #{this.dex}\nhp: #{this.hp}\tXP: #{this.xp}"

			characterSheet: () -> "#{this.name}\n#{this.statSummary()}\n#{this.inventorySummary()}"
			
			doesHit: (target) -> (Cutil.ndice(this.str, 6) > Cutil.ndice(target.dex, 6))

			heal: (n = this.max_hp) -> this.hp = Math.min(this.max_hp, this.hp + n); this.high = false;

			serialize: () -> {
				name: this.name
				str: this.str
				dex: this.dex
				max_hp: this.max_hp
				hp: this.hp
				level: this.level
				xp: this.xp
				inventory: this.inventory
			}

			getHigh: () ->
				drugs = ['skeebie blint','purp scurp']
				available = (d for d of this.inventory when this.inventory[d] > 0)
				if available.length < 1
					return false
				else
					drug = this.inventory[available[0]]
					this.high = true
					this.inventory[drug] = this.inventory[drug] - 1
					delete this.inventory[drug] if this.inventory[drug] == 0
					return true


		}
	takeItem: () ->
		#

	newHero: (name) ->
		this.creature(name, 3 + Cutil.roll(2), 3 + Cutil.roll(2), 6 + Cutil.roll(3))

	heroFromJSON: (json) ->
		c = this.creature(json.name, json.str, json.dex, json.max_hp)
		c.hp = json.hp
		c.level = json.level
		c.xp = json.xp
		c.inventory = json.inventory
		c

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

	monsterTypes: [
		'eddie',
		'tug',
		'socialist',
		'Internet Explorer',
		'BRT',
		'Cantwell',
		'Mike Howe',
		"ANH ANH ANH ANH"
	]

	monsterMods: {
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

	monsterFactory: (lvl) ->
		type = Cutil.getRandom(this.monsterTypes)
		mod = Cutil.getRandom(Object.keys(this.monsterMods))
		baseMonster = this.creature("#{mod} #{type}", Cutil.ndice(lvl, 2), Cutil.ndice(lvl,2), lvl + Cutil.ndice(lvl,3))
		moddedMonster = this.monsterMods[mod](baseMonster)
		moddedMonster.level = lvl
		moddedMonster

	attack: (a, b) ->
		if (Cutil.roll(10) > 1) || a.doesHit(b)
			damage = Cutil.roll(a.str)
			b.hp -= damage
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

