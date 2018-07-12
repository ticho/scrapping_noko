require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

def find_all_currencies
  coin_list_url = "https://coinmarketcap.com/all/views/all/"
  page = Nokogiri::HTML(open(coin_list_url))
  # binding.pry
  currencies = []
  page.css('table#currencies-all tbody tr').each do |x|
    name = x.css('td.currency-name')[0]['data-sort']
    value = x.css('a.price')[0]['data-usd']
    currencies.push({name: name, price: value})
  end
  currencies
end

def main
  currencies = find_all_currencies
  print currencies
end

main
