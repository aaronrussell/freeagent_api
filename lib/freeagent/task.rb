module Freeagent

  class Task < Base
    @elements = ['id', 'project-id', 'name']
    @elements.each {|t| attr_accessor t.underscore.to_sym}

    def self.find(project_id, task_id)
      get '/projects/'+project_id+'/tasks/'+task_id
      tasks = parse('task', @elements)
      return tasks[0]
    end
  end

end