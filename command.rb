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
	    puts "ERROR: Not responding after 10 tries!  Giving up!"
	    exit
	  end
	end
end

$stdout = File.new("output.txt", 'w')
$chapters = File.new("chapter.txt", 'w')

$chapters.sync = true
$stdout.sync = true

# puts "downloading image"
# require 'open-uri'
# download = open('http://h.mhcdn.net/store/manga/14767/176.0/compressed/c000.jpg?token=968f6621aa3f06b362b4d61c5e8178a7&ttl=1491469200')
# IO.copy_stream(download, 'image.png')

puts "inisialisasi browser"
browser = Watir::Browser.new :phantomjs
rootURL = 'www.mangahere.co/manga/douluo_dalu'
gotoURL(120,3){
	puts "go to url"
	browser.goto(rootURL)
}

puts "parsing halaman"
doc = Nokogiri::HTML.parse(browser.html)
totalChapter = doc.css('.detail_list//li//a').count
print "total chapter = "
puts totalChapter

puts "saving url chapter"
$i = 1
$num = totalChapter
chapterURL = Array.new
until $i > $num  do
	imageURL = doc.at_css(".detail_list//li:nth-child(#$i)//a")['href']
	$chapters.puts imageURL
	# str = doc.at_css(".detail_list//li:nth-child(#{$i})//a").text
	# str = str.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
	# chapterName = str.join(' ')
	# chapter = [imageURL, chapterName]
	# chapter = chapter.join(' ')
	# $chapters.puts chapter
	$i +=1;
end

browser.quit