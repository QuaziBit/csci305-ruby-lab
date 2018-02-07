
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

# function to process each line of a file and extract the song titles
def process_file(file_name)

	# local variables declaration

	# start time of this program
	t_1 = Time.now

	# total amount of titles
	total = 0

	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|
			# do something for each line
			
			# call the cleanup_title method and pass the line
			# the cleanup_title method will return cleaned up string
			# the cleaned up string will be stored in the title variable
			title = cleanup_title(line)
			
			# extra check if title string starts with "A"
			if title.match(/^[\A]/)

				# print title
				#puts title

				# count titles
				total += 1
			end
		end

		puts "Finished. Bigram model built.\n"

		# print total amount of titles
		puts "\nTotal number of Titels: #{total}\n"

		# end time of this program
		t_2 = Time.now

		# calculate time needed for computing
		t_3 = t_2 - t_1

		# print computing time
		puts "Computing Time: #{t_3}"

	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

# takes a single string and returns a cleaned up string
def cleanup_title(line)

	# title variable
	title = ""

	# splitting the line by ">"
	# as the result should have 4 different strings
	tmp_1, tmp_2, tmp_3, tmp_4  = line.chomp.split(/>/)

	# the tmp_4 should containing the part of the line where title is located
	# if tmp_4 string matches "A" then continue
	if tmp_4.match(/^[\A]/)

		# if tmp_4 string has English words then continue
		if tmp_4.match(/[a-zA-Z]+$/)

			# splitting up the tmp_4 further
			# after splitting the first part of the tmp_4 string should give back title
			# and the rest what left is the garbage string
			title, garbage = tmp_4.chomp.split(/[\/\()\[\]\:\_\-\+\=\*]/)
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

