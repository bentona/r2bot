#!/bin/bash

#you should have these somewhere, filled out
#export HUBOT_HIPCHAT_JID=
#export HUBOT_HIPCHAT_PASSWORD=
forever start -c coffee node_modules/.bin/hubot -a hipchat

