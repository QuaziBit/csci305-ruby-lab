
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

# function to process each line of a file and extract the song titles
def process_file(file_name)

	# local variables declaration

	# start time of this program
	t_1 = Time.now

	puts "Processing File.... "
	
	# Test: write to text file all titles
	# tmp_line_out = ""

	begin
		IO.foreach(file_name) do |line|
			# do something for each line
			
			# call the cleanup_title method and pass the line
			# the cleanup_title method will return cleaned up string
			# the cleaned up string will be stored in the title variable
			# title = cleanup_title(line)
			cleanup_title(line)

			# Test: write to text file all titles
			#if title != nil
			#	tmp_line_out += "#{title}\n"
			#end	
		
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

		# Test: write to text file all titles
		# File.open("text.txt", 'w') { |file| file.write(tmp_line_out) }

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
		title_tmp_2, garbage = title_tmp.chomp.split(/[\/\()\[\]\:\_\-\+\=\*\@[0-9]]/)

		# ===============================================================
		# Replace spaces within an empty char
		str_no_sp = title_tmp_2.gsub(/\s/,'')
		str_no_sp = str_no_sp.gsub(/\?/,'')
		str_no_sp = str_no_sp.gsub(/\!/,'')
		str_no_sp = str_no_sp.gsub(/\./,'')

		# check if title matches the regular expression
		reg_str = str_no_sp[/[a-zA-Z]+$/]
		is_equal = str_no_sp == reg_str # true or false
		# ================================================================
		
		if is_equal == true

			if title_tmp_2 != ""
				$counter_1 += 1
				title = title_tmp_2
				#puts "*********************\n"
				#puts "[ENG][+]: #{title_tmp_2} ==> #{$counter_1}"
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

