#get input from user: task_name, task_desc, task_due, task_status
#write to .csv with headers: Name, Description, Due, Status
#email list of to do tasks two sections.. Due Today and Past due
#EXTENSION
#allow the user to update status
#strip completed from file
#need more explanation on protecting gmail account information name/password
#read the file and send an email to user
 
# NOTE FROM BRANDON:
# My recommendation is to do `gem install dotenv` and keep variables in 
# a `.env` file that looks like this (without the comment hash marks:
 
# GMAIL_USERNAME=your email here
# GMAIL_PASSWORD=your password here
 
# If you set ENV another way you can comment out the require 'dotenv' line below.
require 'dotenv'
require 'csv'
require 'gmail'
 
Dotenv.load
 
@gmail_username = ENV['GMAIL_USERNAME']
@gmail_password = ENV['GMAIL_PASSWORD']
 
# Opens .csv file and writes headings
def create_file
  if !File.exist?('to_do_genie.csv') 
    CSV.open('to_do_genie.csv', 'ab')    
  end
end

 
def enter_tasks
  puts "ToDo Genie Keeps you on track"

  puts "Enter a task name."
  task_name = gets.chomp

  puts "Enter a description of task."
  task_desc = gets.chomp

  puts "Enter a due date in the format dd/mm/yy"
  task_due = gets.chomp

  until task_due.length == 8 && task_due.include?('/')
    puts "Please enter date in dd/mm/yy format"
    task_due = gets.chomp
  end

  puts "task is saved"
  
  CSV.open('to_do_genie.csv','ab') do |csv|
    csv << [task_name, task_desc, task_due]
    puts "Do you want to add another task? (y or n)"
    answer = gets.chomp
      if answer == 'y'
        enter_tasks
      else
    end
  end
end
 
def create_html_body
  html_email = '<h1> This is what you have going on. </h1>
        <table border="1" bordercolor="#FFCC00" style="background-color:#FFFFCC" width="100%" cellpadding="3" cellspacing="3">
        <tr style="text-align:center">
          <th>Task</th>
          <th>Description</th>
          <th>Due Date</th> 
        </tr>'
  closing_tag = '</table>'
 
  CSV.read('to_do_genie.csv').each do |row|
    html_email << "<tr>\n"
    row.each do |column|
      html_email << "<td>#{column}</td>\n"
    end
    html_email << "</tr>\n"
  end
 
  html_email + closing_tag
end
 
# # send function...
def send_email
  html_body = create_html_body
  
  gmail = Gmail.new(@gmail_username, @gmail_password)
  gmail.deliver do
    to "jswatson0@gmail.com"
    from "jswatson0@gmail.com"
    subject "ToDo Genie"
 
    html_part do
      body html_body
    end 
  end
end
 
# This is the star of your show. It's going to create the file, let you edit, and then send it to you.
def update_and_send_task_list
  create_file
  enter_tasks
  create_html_body
  send_email
end
 
update_and_send_task_list
puts "ToDo Genie has sent your list"
 
 
# This test simply validates that create_file does its job.
# There's a lot more to break up and test here, and it should be moved to another file.
 
# class TestToDoGenie < MiniTest::Unit::TestCase
#   def setup
#     File.delete("to_do_genie.csv") if File.exist?('to_do_genie.csv')
#   end
 
#   def test_create_file_creates_a_file
#     assert !File.exist?('to_do_genie.csv')
#     create_file
 
#     assert File.exist?('to_do_genie.csv')
#   end
 
#   def test_create_file_contains_headers
#     create_file
 
#     assert_equal "Name,Description,Due\n", File.read("to_do_genie.csv")
#   end
# end