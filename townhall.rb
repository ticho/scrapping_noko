require 'nokogiri'
require 'open-uri'
require 'pry'



def get_the_email_of_a_townhal_from_its_webpage(url)
  page = Nokogiri::HTML(open(url))
  page.css('td').each do |str|
    begin
      if str.text.chomp.match?(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i)
        return str.text
      end
    rescue StandardError => e
      puts "Error with #{str.text}: #{e.message}"
    end
  end
  return ""
end


def get_all_the_urls_of_val_doise_townhalls(url)
  page = Nokogiri::HTML(open(url))
  page = page.css('a').select do |a|
    a['class'] == 'lientxt'
  end
  town_list = []
  # uncomment to get the full list
  # page.each do |a|
  page.first(20).each do |a|
    begin
      email = get_the_email_of_a_townhal_from_its_webpage("http://annuaire-des-mairies.com" + a['href'][1..-1])
      town_list.push({name: a.text, email: email})
    rescue StandardError => e
      # puts "Error with #{a.text}: #{e.message}"
    end
  end
  # binding.pry
  return town_list
end

def main
  town_list_url = "http://annuaire-des-mairies.com/"
  townhall_url = "http://annuaire-des-mairies.com/95/vaureal.html"
  town_list_valdoise_url = "http://annuaire-des-mairies.com/val-d-oise.html"
  # puts get_the_email_of_a_townhal_from_its_webpage("http://annuaire-des-mairies.com/95/omerville.html")
  # puts get_the_email_of_a_townhal_from_its_webpage("http://annuaire-des-mairies.com/95/groslay.html")
  # get_the_email_of_a_townhal_from_its_webpage(townhall_url)
  all_towns_emails = get_all_the_urls_of_val_doise_townhalls(town_list_valdoise_url)
  print all_towns_emails
end

main
