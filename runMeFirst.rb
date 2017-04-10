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
