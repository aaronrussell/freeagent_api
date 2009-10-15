module Freeagent

  class Project < Base
    @elements = ['id', 'contact-id', 'name', 'billing-basis', 'budget', 'budget-units', 'invoicing-reference', 'is-ir35', 'normal-billing-rate', 'payment-terms-in-days', 'starts-on', 'ends-on', 'status', 'uses-project-invoice-sequence']
    @elements.each {|t| attr_accessor t.underscore.to_sym}
  
    def self.find_all
      get '/projects'
      projects = parse('projects/project', @elements)
      return projects
    end
  
    def self.find(project_id)
      get '/projects/'+project_id
      projects = parse('project', @elements)
      return projects[0]
    end
  end

end