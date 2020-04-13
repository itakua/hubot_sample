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

  # Help
  robot.respond /bothelp/i, (res) ->
     helpmsg = "\nPlease Mention ctpbot\n"
     helpmsg = helpmsg + "Bothelp Retuen Help Message of ctpbot\n"
     helpmsg = helpmsg + "ping Retuen PONG\n"
     helpmsg = helpmsg + "Shuffule Lunch Retuen 3 restarants near Akasaka from Tabelog\n"
     helpmsg = helpmsg + "Zipcode <zipcode> Retuen Adress Info\n"
     res.reply helpmsg


  # Sample Response
  robot.respond /ping/i, (res) ->
     res.reply "PONG"

  # ShuffulLunch
  robot.respond /Shuffule Lunch/i, (res) ->
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
  
  # Zipcode
  robot.respond /Zipcode\s([0-9]{7})/i, (msg) ->
    zipcode = msg.match[1]
    zipcode = zipcode.trim()
    baseUrl = 'http://zip.cgis.biz/csv/zip.php?zn=' + zipcode
    msg.reply "Request API URL = " + baseUrl
    request baseUrl, (err, res) ->
       if err | res.statusCode != 200
         msg.reply "api call error!"
       else
         rows = res.body.split("\n")
         adrinf = rows[1].split(",")
         address = adrinf[4].replace(/\"/g,'') + adrinf[5].replace(/\"/g,'') + adrinf[6].replace(/\"/g,'')
         # Transrate Encoding
         #Iconv = require('iconv').Iconv
         #iconv = new Iconv('EUC-JP', 'SHIFT_JIS//TRANSLIT//IGNORE');
         #msg.reply iconv.convert(address).toString()
         msg.reply address