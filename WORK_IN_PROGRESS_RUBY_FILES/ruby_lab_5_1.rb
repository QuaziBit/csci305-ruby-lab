
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

            # Build bigram data structure 
            # ====================================================== #
			if title != nil && title != ""
				buildBigram(title)
            end
            # ====================================================== #
			
		end

		puts "Finished. Bigram model built.\n"

        # ====================================================== #
        # print total amount of titles
        puts "\n======================================="
		puts "Total number of Titels: #{$counter_1}\n"

		# end time of this program
		t_2 = Time.now

		# calculate time needed for computing
		t_3 = t_2 - t_1

		# print computing time
        puts "Computing Time: #{t_3}"
        puts "=======================================\n\n"
        # ====================================================== #
        
        # ====================================================== #
        '
        puts "Printing Bigram data..."
        puts "=================================================="
        printBigram()
        puts "==================================================\n"
        '
        # ====================================================== #

        # TEST: now --> happy ::: love --> sad ::: song --> love
		#mcw("happy")


	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

# takes a single string and returns a cleaned up string
def cleanup_title(line)

    # ====================================================== #
	# title variable
	title = nil

	# splitting the line by ">"
	# as the result should have 4 different strings
	# the tmp_4 war should contain title string
    tmp_1, tmp_2, tmp_3, tmp_4  = line.chomp.split(/>/)
    # ====================================================== #

	# ====================================================== #
	# make the first letter of the string uppercase
	str_up = tmp_4
	str_up[0] = str_up[0].upcase
	title_tmp = str_up
	# ====================================================== #

    # ====================================================== #
	if title_tmp.match(/^[\A]/)

		# splitting up the title_tmp further
		# after splitting the first part of the title_tmp string should give back title
		# and the rest what left is the garbage string
		title_tmp_2, garbage = title_tmp.chomp.split(/[\/\(\)\[\]\:\_\-\+\=\*\@\!\?[0-9]]/)

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
			if title_tmp_2 != ""
				$counter_1 += 1
				title = title_tmp_2.downcase!.gsub(/\s+$/,'')
				title = title.gsub(/\.$/,'')
			end	
		end
    end
    # ====================================================== #

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

    # show result
    followed = tmp_hash.key(val_2)
    puts "word: [#{followed}] followed the word: [#{some_word}] [#{val_2}] times"
    # ====================================================== #
    
    return followed

end

def printBigram()
    $bigrams.each do |key, array|
        puts "key: [#{key}] ----- val: #{array}"
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

