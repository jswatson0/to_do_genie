

class TaskList


	def create_file
	  if File.exist?('to_do_genie.csv') == false
		  CSV.open('to_do_genie.csv', 'ab') do |csv|
		    csv << ["Name", "Description", "Due"]
		  end
		end
	end

end

	