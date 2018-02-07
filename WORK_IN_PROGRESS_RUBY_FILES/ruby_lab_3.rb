
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <Olexandr> <Matveyev>
# <alex.matveyev88@gmail.com>
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "<Olexandr> <Matveyev>"

$counter_1 = 0 # total amount of [eng] titles
$counter_2 = 0 # total amount of [non-eng] titles

$words = Hash.new
$titles = Hash.new

$bigram_counter = 0
$bigrams = Hash.new

# function to process each line of a file and extract the song titles
def process_file(file_name)

	# local variables declaration

	# start time of this program
    t_1 = Time.now
    
    title = nil

	puts "Processing File.... "
	
	begin
		IO.foreach(file_name) do |line|
			# do something for each line
			
			# call the cleanup_title method and pass the line
			# the cleanup_title method will return cleaned up string
			# the cleaned up string will be stored in the title variable
			# title = cleanup_title(line)
			title = cleanup_title(line)
			
			test_word = "computer"
			if title != nil && title != ""
				if title.match("#{test_word}")
					puts "==========================="
					puts "#{title}: #{test_word}"
					puts "==========================="
				end
			end
			
			
			if title != nil && title != ""
				buildBigram(title)
                createWordsList(title)
			end
			
			

		end

		puts "Finished. Bigram model built.\n"

		# print total amount of titles
		puts "\nTotal number of Titels: #{$counter_1}\n"

		# end time of this program
		t_2 = Time.now

		# calculate time needed for computing
		t_3 = t_2 - t_1

		# print computing time
        puts "Computing Time: #{t_3}"
        
		#countWords()

		#printWords()
		#printBigram()

		mcw("love")


	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

# takes a single string and returns a cleaned up string
def cleanup_title(line)

	# title variable
	title = nil

	# splitting the line by ">"
	# as the result should have 4 different strings
	# the tmp_4 war should contain title string
	tmp_1, tmp_2, tmp_3, tmp_4  = line.chomp.split(/>/)

	# ===============================================================
	# make the first letter of the string uppercase
	str_up = tmp_4
	str_up[0] = str_up[0].upcase
	title_tmp = str_up
	# ===============================================================

	if title_tmp.match(/^[\A]/)

		# splitting up the title_tmp further
		# after splitting the first part of the title_tmp string should give back title
		# and the rest what left is the garbage string
		title_tmp_2, garbage = title_tmp.chomp.split(/[\/\()\[\]\:\_\-\+\=\*\@\![0-9]]/)

		# ===============================================================
		# Replace spaces within an empty char
		str_no_sp = title_tmp_2.gsub(/\s/,'')
		"
		str_no_sp = str_no_sp.gsub(/\?/,'')
		str_no_sp = str_no_sp.gsub(/\!/,'')
		str_no_sp = str_no_sp.gsub(/\./,'')
		"

		# check if title matches the regular expression
		reg_str = str_no_sp[/[a-zA-Z]+$/]
		is_equal = str_no_sp == reg_str # true or false
		# ================================================================
		
		if is_equal == true
			if title_tmp_2 != ""
				$counter_1 += 1
				title = title_tmp_2.downcase!.gsub(/\s+$/,'')
				title = title.gsub(/\.$/,'')
				#puts "*********************\n"
				#puts "[ENG][+]: #{title} ==> #{$counter_1}"
				#puts "*********************\n"
			end	
		else
			$counter_2 += 1
			#puts "*********************\n"
			#puts "[NON-ENG][-]: #{title_tmp_2} ==> #{$counter_1}"
			#puts "*********************\n"
		end
	end

	# return cleaned up title string
	return title;

end

def createWordsList(title)

	# add single title into Hash
	# $titles[title] = ""

    # split string into the words
    tmp = title.split(" ")

    #puts "====================\n"
    tmp.each do |word|
        # add simgle word into Hash
        $words[word] = 0
    end
    #puts "====================\n"
    
    #$words[title] = title

end

def printWords()

	'
	#$titles.sort_by { |k,v| k.to_s }
	$titles.each do |key, array|
        puts "key: [#{key}] ----- val: #{array}"
	end
	'
	
	
    #$words.sort_by { |k,v| k.to_s }
    $words.each do |key, array|
        puts "key: [#{key}] ----- val: #{array}"
	end
	
end

def buildBigram(title)

	# split string into the words
	tmp = title.split(" ")

	array_size = tmp.length
	tmp_counter = 0;

	first = 0
	last = 1
	pair_counter = 1
	tmp_str = nil
	final_str = ""

	# create bigram
	for word in tmp

		if ( pair_counter < array_size )
			if ( first < last )
				if (first + 1 != array_size)
					# get first word
					tmp_str = "#{tmp[first]}:"
					first = last
				end
			end
			if ( last <= array_size - 1 )
				# get last word
				tmp_str += "#{tmp[last]}"
				last += 1
			end
			if ( last < array_size)
				tmp_str += ","
			end

			final_str += "#{tmp_str}"
		end
		pair_counter += 1

	end

	# save bigram in the Hash array
	if final_str != nil && final_str != ""
		$bigrams[$bigram_counter] = "#{final_str}"
		$bigram_counter += 1
	end
end

def printBigram()
    $bigrams.each do |key, array|
        puts "key: [#{key}] ----- val: #{array}"
	end
	puts "\n"
end

def countWords()
	
	'
	$words.each do |key_1, array_1|
		# puts "key: [#{key}] ----- val: #{array}"
		$bigrams.each do |key_2, array_2|
			# puts "key: [#{key_2}] ----- val: #{array_2}"

			if ( array_2.match("#{key_1}") )
				$words["#{key_1}"] += 1
			end

		end
	end
	'

end

def mcw(some_word)

	# .chomp.split(/[\/\()\[\]\:\_\-\+\=\*\@\![0-9]]/)
	counter = 0
	some_word_index = 0
	tmp_str = ""

	$bigrams.each do |key, array|
		if ( array.match("#{some_word}") )
			#puts array
			#puts array.chomp.split(":#{some_word}")
			#puts array.split(/[\:\,]/)

			tmp_array = array.split(/[\:\,]/)
			puts tmp_array
			puts "\n"
			for word in tmp_array
				if some_word.match("#{word}")
					some_word_index = counter

					if counter != 0 && counter <= tmp_array.length
						tmp_str += tmp_array[counter - 1]
						tmp_str += ":#{some_word}\n"
					end
				end
				counter += 1
			end
			'
			for word in tmp_array
				if word == some_word
					str = tmp_array[some_word_index - 1]
					puts "#{str}: #{some_word}"
				end
			end
			'
			puts tmp_str
			puts "************************************"
			counter = 0
			some_word_index = 0
		end
		tmp_str = ""
	end
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
end

if __FILE__==$0
	main_loop()
end

