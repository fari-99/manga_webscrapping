def gotoURL(timeout, tries)
	begin
	  Timeout::timeout(timeout) do
	    yield
	  end
	rescue Timeout::Error
	  if tries > 0
	    puts "Timeout - Retrying..."
	    tries -= 1
	    retry
	  else
	    puts "ERROR: Not responding after #{tries} tries!  Giving up!"
	    exit
	  end
	end
end

puts "--------------------------------------------------------------------"
puts "----------------------- Inisialisasi Browse ------------------------"
puts "--------------------------------------------------------------------"

browser = Watir::Browser.new :phantomjs
rootURL = 'www.mangahere.co/manga/douluo_dalu'
gotoURL(120,3){
	browser.goto(rootURL)
}

puts "--------------------------------------------------------------------"
puts "------------------------- Parsing Halaman --------------------------"
puts "--------------------------------------------------------------------"
doc = Nokogiri::HTML.parse(browser.html)
#totalChapter = doc.css('.detail_list//li//a').count
judul = doc.at_css("//h1[@class='title']").text

puts "--------------------------------------------------------------------"
puts "------------------------ Saving Chapter URL ------------------------"
puts "--------------------------------------------------------------------"

#creating hash
# hash_for_json = Hash.new
# hash_for_json['key'] = value

#creating array
# arr_for_json = Array.new
# arr_for_json.push ['key', 'value']

# hash or array -> json
# require 'json'
# hash_for_json.to_json
# arr_for_json.to_json

# pretty json
# puts JSON.pretty_generate(hash_for_json)
# puts JSON.pretty_generate(arr_for_json)

$i = 1
$num = doc.css('.detail_list//li//a').count
chapterURL = Hash.new
until $i > $num  do
	imageURL = doc.at_css(".detail_list//li:nth-child(#{$i})//a")['href']
	chapterURL.putc imageURL
	# str = doc.at_css(".detail_list//li:nth-child(#{$i})//a").text
	# str = str.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
	$i +=1;
end

browser.quit
exit
