require 'uri'
require 'httparty'
require 'json'
require 'openssl'
require 'net/http'

class BinanceApi
  attr_reader :key, :secret_key, :headers
  END_POINT = 'https://api.binance.com'.freeze
  RECV_WINDOW = 50000

  def initialize(key, secret_key)
    @key = key
    @secret_key = secret_key
    @headers = {
      'X-MBX-APIKEY': key,
      'Content-Type': 'text/json'
    }
  end

  def account_info
    uri = URI("#{END_POINT}/api/v3/account")
    params = {
      recvWindow: 5000,
      timestamp: get_timestamp
    }
    signature = generate_signature(URI.encode_www_form(params))
    query = params.merge(signature: signature)
    uri.query = URI.encode_www_form(query)
    request = Net::HTTP::Get.new(uri)
    request["X-MBX-APIKEY"] = key
    req_options = {
      use_ssl: uri.scheme == "https"
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    #res = HTTParty.get(uri, headers: headers, body: query)
    JSON.parse(res.body)
  end

  def get_timestamp
    Time.now.utc.strftime("%s%3N")
  end

  def generate_signature(data)
    digest = OpenSSL::Digest.new('sha256')
    signature = OpenSSL::HMAC.hexdigest(digest, secret_key, data)
  end

end

