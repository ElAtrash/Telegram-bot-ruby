require "telegram/bot"
require "nokogiri"
require "open-uri"

# replace your_token with a token from botfather
TOKEN = "your_token"

module LiquidSales
  class Sigaretnet
    XPATH_WEEK = '//div[@class="jcomments-links"]/a[contains(@title, "Товары недели")]/@href'

    def initialize
      @site_name = "http://www.sigaretnet.by"
      @sales_page = Nokogiri::HTML.parse(open("http://www.sigaretnet.by/aktsii.html"))
    end

    def get_week_sale_url
      @site_name + @sales_page.xpath(XPATH_WEEK).text
    end

    def parse_week_sales
      week_sales = Nokogiri::HTML.parse(open(get_week_sale_url))
      items_img_urls = week_sales.xpath('//div[@class="item-pageakcii-p"]//p/img/@src').map do |img_url|
        @site_name + img_url.text
      end
      items_img_urls
    end
  end

  class SigaretnetTelegramBot
    def initialize
      @sigaretnet = Sigaretnet.new
    end

    def run
      Telegram::Bot::Client.run(TOKEN) do |bot|
        bot.listen do |message|
          case message.text
          when "/start"
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "Здравствуй, #{message.from.first_name}.\n/help для навигации."
            )
          when "/week"
            @sigaretnet.parse_week_sales.each {|img| bot.api.send_message(chat_id: message.chat.id, text: img) }
          when "/help"
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "/week - чтобы узнать недельную акцию.\n/help - для навигации."
             )
          else
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "/help для навигации."
             )
          end
        end
      end
    end # run  
  end
end

sigaretnet_bot = LiquidSales::SigaretnetTelegramBot.new
sigaretnet_bot.run