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

def downloadImage(doc, fileLoc, counter)
	id = doc.at_css("//section[@id='viewer']//a img")["id"]
	if id == "loading"
		id = doc.at_css("//section[@id='viewer']//a img:nth-child(2)")["id"]
		if id == "image"
			imageSrc = doc.at_css("//section[@id='viewer']//a img:nth-child(2)")["src"]
		else
			puts "--- image not loaded trying to refresh page"
			exit
		end
	elsif id == "image"
			imageSrc = doc.at_css("//section[@id='viewer']//a img")["src"]
	else
			puts "--- image not loaded trying to refresh page"
			exit
	end
	require 'open-uri'
	download = open(imageSrc)
	IO.copy_stream(download, "#{fileLoc}#{counter}.jpg")
end

def downloadChapter(browser, judul, chapter, urlChapter)
	timeout = 120
	tries = 10

	puts "--------------------------------------------------------------------"
	puts "--------------------- try connect to chapter -----------------------"
	puts "--------------------------------------------------------------------"
	gotoURL(timeout, tries){
		browser.goto(urlChapter)
	}

	#check berapa image 1 chapter
	doc = Nokogiri::HTML.parse(browser.html)
	puts "image count"
	countPage = doc.css("//span[@class='right']//select//option").count / 2

	puts "--------------------------------------------------------------------"
	puts "------------------------- downloading image ------------------------"
	puts "--------------------------------------------------------------------"
	$i = 1
	$num = countPage
	until $i > $num do 
		getURLPage = doc.at_css("//span[@class='right']//select//option:nth-child(#{$i})")['value']
		puts "download image #{$i}"
		gotoURL(timeout, tries){
			browser.goto(getURLPage)
		}

		doc = Nokogiri::HTML.parse(browser.html)
		downloadImage(doc, "downloadedImage/", $i)
		$i += 1
	end
end

browser = Watir::Browser.new :phantomjs


filename = 'chapter.txt'
File.foreach(filename).with_index do |url, line_num|
 	
 	if line_num == 1
 		judul = line
 	else
 		puts "--------------------------------------------------------------------"
	 	puts "------------------- downloading chapter #{url} ---------------------"
	 	puts "--------------------------------------------------------------------"

	 	downloadChapter(browser, judul, line_num, line)

		puts "--------------------------------------------------------------------"
	 	puts "------------------------ end chapter #{url} ------------------------"
	 	puts "--------------------------------------------------------------------"
	end
end
