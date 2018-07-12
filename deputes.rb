require 'nokogiri'
require 'open-uri'
require 'pry'


def find_email_from_url(url)
  mails = []
  page = Nokogiri::XML(open(url))
  # binding.pry
  page = page.css('html body div#contenu div#corps_page div.contenu_page div.contenu_depute div#b1.boite_depute ul li ul li a')
  page.each do |a|
    if a.text.chomp.match?(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i)
      mails.push(a.text.chomp)
    end
  end
  mails
end

def get_all_deputes_emails(url)
  mails = []
  page = Nokogiri::XML(open(url))
  page = page.css('div.liste div.list_table td a')
  # page.each do |a|
  # only the top of the list for the test
  page.first(10).each do |a|
    # trying to cleanup the str
    name = a.css('span.list_nom').text.gsub(/[^a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]/i, '')
    first_name = name.split(',')[1].chomp.delete(' ')
    last_name = name.split(',')[0].chomp.delete(' ')
    deputee_url = "https://www.nosdeputes.fr" + a.to_a[0][1]
    email = find_email_from_url(deputee_url)
    mails.push({first_name: first_name, last_name: last_name, email: email})
  end
  mails
end

def main
  list_url = "https://www.nosdeputes.fr/deputes"
  # url_ruffin = "https://www.nosdeputes.fr/francois-ruffin"
  # find_email_from_url(url_ruffin)
  print get_all_deputes_emails(list_url)
end

main
