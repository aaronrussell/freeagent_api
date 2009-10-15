module Freeagent

  class Timeslip < Base
    @elements = ['id', 'dated-on', 'project-id', 'task-id', 'task', 'user-id', 'hours', 'comment']
    @elements.each {|t| attr_accessor t.underscore.to_sym}

    def self.find_all(project_id = false)
      if project_id
        get '/projects/'+project_id+'/timeslips'
      else
        get '/timeslips'
      end
      timeslips = parse('timeslips/timeslip', @elements)
      timeslips.each do |t|
        t.task = Task.find(project_id, t.task_id)
      end
      return timeslips.reverse
    end
  
    def self.find(timeslip_id)
      get '/timeslips'+timeslip_id
      timeslips = parse('timeslip', @elements)
      return timeslips[0]
    end
  end

module Freeagent