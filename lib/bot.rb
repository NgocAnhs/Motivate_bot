require 'telegram/bot'
require_relative 'motivate.rb'
require_relative 'binance_api'

class Bot
  def initialize
    token = '1974224873:AAGiXTtXyiE9Fry2xtn4OivcKPkkbI6snGo'
    key = "uSVlopSP2eNIxWyOLmXUNiqttfXtRNbJoQinI1DQxLISlFFEEei0WS0fL9zcDzez"
    secret_key = "icm8zHwQOk5kg6qoBkKsnQB5cXsDmp6887MsD8YBCrmtHA6t19LdMt6FoFvgeqkw"
    bnb_api = BinanceApi.new(key, secret_key)

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name} , welcome to motivation chat bot created by Ping, the chat bot is to keep you motivated and entertained. Use  /start to start the bot,  /stop to end the bot, /motivate to get a diffrent motivational quote everytime you request for it or /balance_info to get balance binance account")
        when '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}", date: message.date)
        when '/motivate'
          values = Motivate.new
          value = values.select_random
          bot.api.send_message(chat_id: message.chat.id, text: "#{value['text']}", date: message.date)
        when '/balance_info'
          values = bnb_api.account_info
          mess = get_balances(values)
          bot.api.send_message(chat_id: message.chat.id, text: mess, date: message.date)
        else bot.api.send_message(chat_id: message.chat.id, text: "Invalid entry, #{message.from.first_name}, you need to use  /start,  /stop , /motivate or /joke")
        end
      end
    end
  end

  def get_balances(value)
    messages = []
    value["balances"].each do |item|
      next if item["free"].to_i == 0 && item["locked"].to_i == 0
      messages << "asset: #{item['asset']} \nfree: #{item['free']} \nlocked: #{item['locked']}"
    end
    messages.join("\n-----------------\n")
  end
end

