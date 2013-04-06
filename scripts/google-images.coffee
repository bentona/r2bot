# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot image me <query> - The Original. Queries Google Images for <query> and returns a random top result.
#   hubot animate me <query> - The same thing as `image me`, except adds a few parameters to try to return an animated GIF instead.
#   hubot mustache me <url> - Adds a mustache to the specified URL.
#   hubot mustache me <query> - Searches Google Images for the specified query and mustaches it.
#   hubot shiba me - Returns a random image from shibaconfessions.tumblr.com.

module.exports = (robot) ->
  robot.respond /(image|img)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

  robot.respond /animate( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[2], true, (url) ->
      msg.send url

  robot.respond /shiba(?: me)?/i, (msg) ->
    imageMe msg, '', false, false, true, "shibaconfessions.tumblr.com", (url) ->
      msg.send url

  robot.respond /(?:mo?u)?sta(?:s|c)he?(?: me)? (.*)/i, (msg) ->
    type = Math.floor(Math.random() * 3)
    mustachify = "http://mustachify.me/#{type}?src="
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{mustachify}#{imagery}"
    else
      imageMe msg, imagery, false, true, (url) ->
        msg.send "#{mustachify}#{url}"

imageMe = (msg, query, animated, faces, randomPage, site, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  cb = randomPage if typeof randomPage == 'function'
  cb = site if typeof site == 'function'

  q = v: '1.0', rsz: '8', q: query, safe: 'off'
  q.imgtype = 'animated' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  q.as_sitesearch = site if typeof site is 'string'

  googImgSearch(q, msg, randomPage, cb)

randomPageImg = (respData, q, msg, cb) ->
  cursor = respData.cursor
  pages = if typeof cursor.pages[0] is 'array' then cursor.pages[0] else cursor.pages

  if pages?.length > 0
    q.start = msg.random(pages).start
    if q.start != cursor.currentPageIndex
      googImgSearch(q, msg, false, cb)
    else
      currentPageImg(respData, msg, cb)

currentPageImg = (respData, msg, cb) ->
  images = respData.results
  if images?.length > 0
    cb "#{msg.random(images).url}#.png"
  else
    cb "lol...wut"

googImgSearch = (q, msg, randomPage, cb) ->
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      imgResponse = JSON.parse(body)
      respData = imgResponse.responseData
      if randomPage
        randomPageImg(respData, q, msg, cb)
      else
        currentPageImg(respData, msg, cb)
