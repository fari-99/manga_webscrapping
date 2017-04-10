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

settingFile  = File.exists? Rails.root.join('setting.json')
if settingFile != false
	puts "---- Reading Setting File ----"
	setting = File.read(Rails.root.join('setting.json'))
	setting = JSON.parse(setting)
else
	puts "---- File setting not found ----"
	puts "---- Creating setting file ----"
	setting = Hash.new
	setting["folder_default"] = Rails.root.join("manga")
	setting["chapter_named"] = "number"
	setting["adding_zero"] = true
	File.open(Rails.root.join('setting.json'),"w") do |f|
    f.write(JSON.pretty_generate(setting))
	end
end

mangaDir     = File.exists? setting['folder_default']
if mangaDir == false
	puts "---- Folder Manga Downloader not found ----"
	puts "---- Creating Manga Folder ----"
	system 'mkdir', setting['folder_default']
else
	puts "---- Folder Manga Downloader found ----"
end

queueFile    = File.exists? Rails.root.join('queue.json')
if queueFile != false
	puts "---- Reading Queue File ----"
	queue = File.read(Rails.root.join('queue.json'))
	queue = JSON.parse(queue)
else
	puts "---- File Queue not found ----"
	puts "---- Creating Queue file ----"
	queue = Hash.new
	File.open(Rails.root.join('queue.json'),"w") do |f|
    f.write(JSON.pretty_generate(queue))
	end
end

bookmarkFile = File.exists? Rails.root.join('bookmark.json')
if bookmarkFile != false
	puts "---- Reading Bookmark File ----"
	bookmark = File.read(Rails.root.join('bookmark.json'))
	bookmark = JSON.parse(bookmark)
else
	puts "---- File Bookmark not found ----"
	puts "---- Creating Bookmark file ----"
	bookmark = Hash.new
	File.open(Rails.root.join('bookmark.json'),"w") do |f|
    f.write(JSON.pretty_generate(bookmark))
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
