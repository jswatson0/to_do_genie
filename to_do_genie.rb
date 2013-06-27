#get input from user: task_name, task_desc, task_due, task_status
#write to .csv with headers: Name, Description, Due, Status
#email list of to do tasks where date matches today 
#EXTENSION
#allow the user to update status
#strip completed from file
#need more explanation on protecting gmail account information name/password
#read the file and send an email to user
#We added ruby-gmail gem but tried to run bundle install and failed needed?

require 'csv'
require 'gmail'


# Opens .csv file and writes headings
 
def create_file
 if File.exist?('to_do_genie.csv') == false
 CSV.open('to_do_genie.csv', 'ab') do |csv|
    csv << ["Name", "Description", "Due"]
  end
end

def get_task    
  puts "Enter a task name."
  @task_name = gets.chomp 
  	puts "Enter a description of task."
  @task_desc = gets.chomp
  	puts "Enter a due date in the format dd/mm/yy"
  @task_due = gets.chomp
	until @task_due.length == 8 && @task_due.include?('/')
		puts "Please enter date in dd/mm/yy format"
		@task_due = gets.chomp
	end
	  puts "task is saved"
    CSV.open('to_do_genie.csv','ab') do |csv|
      csv << [@task_name, @task_desc, @task_due]
      puts "Do you want to add another task? (y or n)"
      answer = gets.chomp
      if answer == 'y'
        get_task
      else
        puts "Goodbye"
      end
    end
  end
end

 # f = File.open('to_do_genie.csv','r')
# d
#   puts CSV.read('to_do_genie.csv').each do 
#   |item| puts item.join(', ')
# end
# end

def send_email
  f = CSV.read('to_do_genie.csv').each do 
  |item| puts item.join(', ')
  Gmail.new(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD']) do |gmail|
    gmail.deliver do
      to "jswatson0@gmail.com"
      from "jswatson0@gmail.com"
      subject "Having fun in Puerto Rico!"
      text_part do
        body "#{f}"
      end 
    end
  end 
end
end  





#    If you pass a block, the session will be passed into the block,
#    and the session will be logged out after the block is executed.
# gmail = Gmail.new(username, password)
# # ...do things...
# gmail.logout

# Gmail.new(username, password) do |gmail|
#   # ...do things...
# end
# gmail.deliver do
#   to "email@example.com"
#   subject "Having fun in Puerto Rico!"
#   text_part do
#     body "Text of plaintext message."
#   end
#   html_part do
#     body "<p>Text of <em>html</em> message.</p>"
#   end
#   add_file "/path/to/some_image.jpg"
# end