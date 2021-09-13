require 'sinatra'
get '/' do
  redirect 'http://t.me/aiembot', 303
end
