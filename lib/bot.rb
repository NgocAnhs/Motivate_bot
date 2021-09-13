require 'telegram/bot'
require_relative 'motivate.rb'

class Bot
  def initialize
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
        else bot.api.send_message(chat_id: message.chat.id, text: "Invalid entry, #{message.from.first_name}, you need to use  /start,  /stop , /motivate or /joke")
        end
      end
    end
  end
end

