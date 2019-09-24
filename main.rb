require "telegram/bot"
require "nokogiri"
require "open-uri"


TOKEN = "818432671:AAFumlZVkn5hcJvkiGnowtomPXcQupqNSuQ"

url = Nokogiri::HTML.parse(open("http://www.sigaretnet.by/aktsii.html"))
url_pref = "http://www.sigaretnet.by"
xpath_d = url.xpath("//div[@class = 'img-intro-left']/img/@src")[1].text.gsub(' ', '%20')
DAILY_SALE = url_pref + xpath_d

xpath_dayinfo = url.xpath("//a[@class='readmore-link']/@href")[1].text
DAY_INFO = url_pref + xpath_dayinfo

xpath_w = url.xpath("//div[@class = 'img-intro-left']/img/@src")[2].text.gsub(' ', '%20')
WEEK_SALE = url_pref + xpath_w

xpath_weekinfo = url.xpath("//a[@class='readmore-link']/@href")[2].text
WEEK_INFO = url_pref + xpath_weekinfo

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when "/start"
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Здравствуй, #{message.from.first_name}.\n/help для навигации."
        )
    when "/about_day"
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "#{DAY_INFO}"
        )
    when "/day"
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "#{DAILY_SALE}"
        )
    when "/about_week"
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "#{WEEK_INFO}"
        )
    when "/week"
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "#{WEEK_SALE}"
        )
    when "/help"
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "/day - чтобы узнать ежедневную акцию.\n/about_day - ссылка на страницу акции.\n/week - чтобы узнать недельную акцию.\n/about_week- ссылка на страницу недельной акции.\n/help - для навигации."
        )
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "/help для навигации."
        )
    end
  end
end
