# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
cheerio = require 'cheerio'
request = require 'request'

module.exports = (robot) ->

  # Sample Response
  robot.hear /ping/i, (res) ->
     res.reply "PONG"

  # ShuffulLunch
  robot.hear /shuffuleLunch/i, (res) ->
      # Search Tabelog  (Akasaka Lunch 1000jpy)
      baseUrl = 'https://tabelog.com/tokyo/A1308/rstLst/lunch/?LstCosT=1&RdoCosTp=1'
      
      request baseUrl, (_, hres) ->
          $ = cheerio.load hres.body
          restaurants = []
          $('.list-rst__rst-name-target').each ->
            a = $ @
            restarant = a.text() + ' ' + a.attr('href')
            restaurants.push(restarant)
          
          # Replay Three Items (Random) 
          idx = Math.floor(Math.random() * restaurants.length)
          res.reply restaurants[idx]
          restaurants.splice(idx,1)
          idx = Math.floor(Math.random() * restaurants.length)
          res.reply restaurants[idx]
          restaurants.splice(idx,1)
          idx = Math.floor(Math.random() * restaurants.length)
          res.reply restaurants[idx]