# require '../coffer.coffee'
#message.user.id
###
module.exports = (robot) ->
	robot.respond /^`(.*)/, (msg) ->
		command = msg.match[1]
		switch command
			when 'a' then adventure()
			when 'c' then characterSheet()
			when 'i' then inventorySheet()
			when 'h' then help()
			else
				msg.send("That's not a valid command. Try `h.")
###