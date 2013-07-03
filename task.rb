
class Task
	# attr_accessor :name, :description, :due_at

	@@task_list =[]

	def initialize(name,description,due_at)
		@name = name
		@description = description
		@due_at = due_at
		@@task_list << self
	end

	def self.all_tasks
		@@task_list
	end

	

end







