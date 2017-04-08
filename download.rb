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

def downloadImage(doc, fileLoc, counter)
	id = doc.at_css("//section[@id='viewer']//a img")["id"]
	if id == "loading"
		id = doc.at_css("//section[@id='viewer']//a img:nth-child(2)")["id"]
		if id == "image"
			imageSrc = doc.at_css("//section[@id='viewer']//a img:nth-child(2)")["src"]
		else
			puts "image not loaded trying to refresh page"
			exit
		end
	elsif id == "image"
			imageSrc = doc.at_css("//section[@id='viewer']//a img")["src"]
	else
			puts "image not loaded trying to refresh page"
			exit
	end
	require 'open-uri'
	download = open(imageSrc)
	IO.copy_stream(download, "#{fileLoc}#{counter}.jpg")
end

browser = Watir::Browser.new :phantomjs
timeout = 120
tries = 10
gotoURL(timeout, tries){
	puts "go to chapter url"
	browser.goto("http://www.mangahere.co/manga/douluo_dalu/c176/")
}

#check berapa image 1 chapter
doc = Nokogiri::HTML.parse(browser.html)
puts "image count"
countPage = doc.css("//span[@class='right']//select//option").count / 2

puts "----------------- image download ------------------"
$i = 1
$num = countPage
until $i > $num do 
	getURLPage = doc.at_css("//span[@class='right']//select//option:nth-child(#{$i})")['value']
	gotoURL(timeout, tries){
		puts "go to image page #{$i}"
		browser.goto(getURLPage)
	}

	doc = Nokogiri::HTML.parse(browser.html)
	downloadImage(doc, "downloadedImage/", $i)
	$i += 1
end


# filename = 'chapter.txt'
# File.foreach(filename).with_index do |url, line_num|
#  	# puts "#{line_num}: #{line}"
 	
# end