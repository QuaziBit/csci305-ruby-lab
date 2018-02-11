
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

# total amount of [eng] titles
$counter_1 = 0

# total amount of [non-eng] titles
$counter_2 = 0

$bigram_counter = 0
$bigrams = Hash.new

$new_title = ""

$t_1 = nil
$t_2 = nil

# function to process each line of a file and extract the song titles
def process_file(file_name)

	# start time of this program
    $t_1 = Time.now
	
	# local variables declaration
    title = ""

	puts "Processing File.... "
	
	begin

		if RUBY_PLATFORM.downcase.include? 'mswin'
			file = File.open(file_name)
			unless file.eof?
				file.each_line do |line|
					# do something for each line (if using windows)
					try_cleanup_title(line)
				end
			end
			file.close
		else
			IO.foreach(file_name, encoding: "utf-8") do |line|
				# do something for each line (if using macos or linux)
				try_cleanup_title(line)
			end
		end
		puts "Finished. Bigram model built.\n"
		
		'
		IO.foreach(file_name) do |line|

			# ====================================================== #
			# do something for each line
			try_cleanup_title(line)
            # ====================================================== #
			
		end
		puts "Finished. Bigram model built.\n"
		'
		
		
		print_time()
		print_extra_info()

	rescue => e
		puts "[1]"
		puts "Exception Class: #{ e.class.name }"
		puts "Exception Message: #{ e.message }"
		puts "Exception Backtrace: #{ e.backtrace }"
		STDERR.puts "Could not open file"
		exit 4
	end
	
end

def try_cleanup_title(line)

	# ====================================================== #
	# call the cleanup_title method and pass the line
	# the cleanup_title method will return cleaned up string
	# the cleaned up string will be stored in the title variable
	# title = cleanup_title(line)
	if line != nil

		begin
			title = cleanup_title(line)
		rescue => e
			puts "[0]"
			puts "Exception Class: #{ e.class.name }"
			puts "Exception Message: #{ e.message }"
			puts "Exception Backtrace: #{ e.backtrace }"
		end

	end
	# ====================================================== #

	# Build bigram data structure 
	# ====================================================== #
	if title != nil && title != ""
		buildBigram(title)
	end
	# ====================================================== #

end

# takes a single string and returns a cleaned up string
def cleanup_title(line)

    # ====================================================== #
	# title variable
	title = ""

	# splitting the line by ">"
	# as the result should have 4 different strings
	# the tmp_4 war should contain title string
	tmp_array = line.chomp.split(/>/)
	tmp_line = tmp_array[tmp_array.length - 1]
	# ====================================================== #

	if tmp_line != nil && tmp_line != ""

		# ====================================================== #
		# splitting up the title_tmp further
		# after splitting the first part of the title_tmp string should give back title
		# and the rest what left is the garbage string
		title_tmp_2, garbage = tmp_line.chomp.split(/[\/\(\)\[\]\:\_\-\+\=\*\@\!\?]/)

		# remove numbers from title
		begin

			if title_tmp_2.match(/[0-9]/)
				title_tmp_2 = title_tmp_2.gsub(/[0-9]/,'')
			end
		  
		rescue => e
			puts "[3]: Exception [remove number from title]"
			'
			puts "Exception Class: #{ e.class.name }"
			puts "Exception Message: #{ e.message }"
			puts "Exception Backtrace: #{ e.backtrace }"
			'
		end

		# remove spaces in beginning of title
		begin

			#title_tmp_2 = title_tmp_2.gsub(/^\s/,'')
			if title_tmp_2.match(/^\s/)
				title_tmp_2 = title_tmp_2.gsub(/^\s/,'')
			end
		  
		rescue => e
			puts "[4]: Exception [remove spaces in beginning of title]"
			'
			puts "Exception Class: #{ e.class.name }"
			puts "Exception Message: #{ e.message }"
			puts "Exception Backtrace: #{ e.backtrace }"
			'
		end


		# ====================================================== #

		if title_tmp_2 != nil && title_tmp_2 != ""

			# ====================================================== #
			# Replace spaces within an empty char
			str_no_sp = title_tmp_2.gsub(/\s/,'')
			str_no_sp = str_no_sp.gsub(/\./,'')
			str_no_sp = str_no_sp.gsub(/\'/,'')
			str_no_sp = str_no_sp.gsub(/\"/,'')
			str_no_sp = str_no_sp.gsub(/\`/,'')
				
			# check if title matches the regular expression
			reg_str = str_no_sp[/[a-zA-Z]+$/]
			is_equal = str_no_sp == reg_str # true or false
			# ====================================================== #
				
			if is_equal == true

				begin
					title = title_tmp_2.downcase!
					#title = title.gsub(/\s+$/,'') # remove space at the end of string caused ERROR
					#title = title.gsub(/\.$/,'') # remove dot at the end of string caused ERROR
					#puts "title: [#{title}]" # test
					$counter_1 += 1
				rescue => e
					puts "[END]"
					puts "Exception Class: #{ e.class.name }"
					puts "Exception Message: #{ e.message }"
					puts "Exception Backtrace: #{ e.backtrace }"
				end

			end
			# ====================================================== #

		end

	end

	# return cleaned up title string
	return title;

end

def buildBigram(title)

	# split string into the words
    tmp = title.split(" ")
    
    # ====================================================== #
	array_size = tmp.length
	tmp_counter = 0;

	first = 0
	last = 1
	pair_counter = 1
	tmp_str = nil
    final_str = ""
    # ====================================================== #

    # create bigram
    # ====================================================== #
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
                # split pair of words
				tmp_str += ","
			end

			final_str += "#{tmp_str}"
		end
		pair_counter += 1

    end
    # ====================================================== #

    # save bigram in the Hash
    # ====================================================== #
	if final_str != nil && final_str != ""
		$bigrams[$bigram_counter] = "#{final_str}"
		$bigram_counter += 1
    end
    # ====================================================== #

end

def mcw(some_word)

    # ====================================================== #
    tmp_hash = Hash.new
    words_list = Array.new

	counter = 0
    followed = ""
    # ====================================================== #

    # ====================================================== #
	$bigrams.each do |key, array|
		if ( array.match("#{some_word}") )

            # split string
            tmp_array = array.split(/[\:\,]/)
            
            # loop through splitted string to find [some word]
			for word in tmp_array

				if some_word == word

					if counter < tmp_array.length

						# get word that is 
						if tmp_array[counter + 1] != "" && tmp_array[counter + 1] != nil
							if tmp_array[counter + 1] != some_word

								followed = tmp_array[counter + 1]
                                tmp_hash[followed] = 0
								words_list.push(followed)

							end
                        end

					end
					
				end
				counter += 1

			end
			counter = 0

		end
    end
    # ====================================================== #
    

    # ====================================================== #
    # count similar words to find the most common word 
    tmp_hash.each do |key, array|
        for word in words_list
            if word == key
                tmp_hash["#{key}"] += 1
            end
        end
	end
	 # ====================================================== #

	# ====================================================== #
    # find the most common word by its [int] value
    val_1 = -1
	val_2 = -2
	tmp_hash.keys.each_with_index do |key, index|
		val_1 = tmp_hash["#{key}"]
		if val_1 > 0
			if val_2 < val_1
				val_2 = val_1
			end
		end
		val_1 = -1
	end
    followed = tmp_hash.key(val_2)
	# ====================================================== #

    # show result
    puts "word: [#{followed}] followed the word: [#{some_word}] [#{val_2}] times"
    # ====================================================== #
	
    return followed

end

def create_title(word)

	# reset $new_title
	$new_title = ""
	build_title(word)

	str = ""
	str = $new_title.gsub(/\s+$/,'')

	return str

end

$i = 1
$showWord = true
def build_title(word)
	
	if $showWord
		puts "Working on [#{word}]"
		$showWord = false
	else
		puts "Working... "
	end
	STDOUT.flush

	str = word
	
	# recursive call of mcw()
	if $i <= 21
		$new_title += "#{str} "
		$i += 1
		str =  build_title( mcw(str) )
	end
	$i = 1
	$showWord = true

end

'
def stst(input)
	puts "\nYou entered [#{input}]"
	STDOUT.flush	

	str = "#{input} "
	str += mcw(input)

	$new_title += "#{str} "
end
'

def user_input()

	exit_loop = false

	input = ""

	while !exit_loop

		if $new_title != ""
			puts "\nNew title: [#{$new_title}]\n"
			STDOUT.flush
			$new_title = ""
		end

		print "\nEnter a word [Enter 'q' to quit]: "
		STDOUT.flush

		input = STDIN.gets.chomp

		if input == "q"
			exit_loop = true
			break
		else		
			#stst(input)
			#build_title(input)
			create_title(input)
			exit_loop = false
		end
	end

end

def printBigram()
    $bigrams.each do |key, array|
		puts "key: [#{key}] ----- val: #{array}"
		'
		if array.match("computer")
			puts "\t\tkey: [#{key}] ----- val: #{array}"
		end
		'
	end
end

def print_time()
    # ====================================================== #
    # print total amount of titles
    puts "\n======================================="
	puts "Total number of Titels: #{$counter_1}\n"

	# end time of this program
	$t_2 = Time.now

	# calculate time needed for computing
	t_3 = $t_2 - $t_1

	# print computing time
    puts "Computing Time: #{t_3}"
    puts "=======================================\n\n"
	# ====================================================== #
	
end

def print_extra_info()
        # ====================================================== #
        '
        puts "Printing Bigram data..."
        puts "=================================================="
        printBigram()
		puts "==================================================\n"
		'
        # ====================================================== #

		# ====================================================== #
		# TEST: now --> happy ::: love --> sad ::: song --> love
		puts "# ====================================================== #"
		mcw("happy")
		mcw("sad")
		mcw("love")
		mcw("computer")
		puts "# ====================================================== #\n\n"

		#create_title("happy")
		#puts $new_title
		#create_title("sad")
		#puts $new_title
		#create_title("hey")
		#puts $new_title
		#create_title("little")
		#puts $new_title
		# ====================================================== #

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
	user_input()
end

if __FILE__==$0
	main_loop()
end

