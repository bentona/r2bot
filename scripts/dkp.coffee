# Description:
#   DKP
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   dkp minus <username> - take points from <username>
#		dkp plus <username> - give points from <username>
#   dkp - list all dkp
#
# Author:
#   brettlangdon / bentona
#

points = {}

award_points = (msg, username) ->
    points[username] ?= 0
    points[username] += 1
    msg.send 'dkp awarded to ' + username

take_points = (msg, username) ->
	points[username] ?= 0
	points[username] -= 1
	msg.send 'dkp taken from ' + username

save = (robot) ->
    robot.brain.data.points = points

module.exports = (robot) ->
    robot.brain.on 'loaded', ->
        points = robot.brain.data.points

    robot.hear /dkp plus (.*?)\s?$/i, (msg) ->
				users = robot.brain.usersForFuzzyName(msg.match[0].trim())
				if users.length is 1
					username = users[0]
					award_points(msg, msg.match[1], msg.match[2])
        	save(robot)
				else if users.length > 1
					msg.send "Too many users like that"
				else
					msg.send "Never heard of them"

    robot.hear /dkp minus (.*?)\s?$/i, (msg) ->
        users = robot.brain.usersForFuzzyName(msg.match[0].trim())
				if users.length is 1
					username = users[0]
					if points[username] is 0
						msg.send username + " is a loser and doesn't have any points"
					else
						take_points(msg, username)
         
         save(robot)

    robot.hear /dkp (list|count|score)/i, (msg) ->
       	m = ''
				for u in robot.brain.users
					points[u] ?= 0
					m += u + ': ' + points[u] + "\n"
        msg.send m
       
