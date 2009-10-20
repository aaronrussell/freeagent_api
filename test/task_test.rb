require 'test_helper'


class TaskTest < Test::Unit::TestCase
  
  context "Task class" do
    should "have correct collection path" do
      assert Task.collection_path(:project_id => 1000) === '/projects/1000/tasks.xml'
    end
    should "have correct element path" do
      assert Task.element_path(:first, :project_id => 1000) === '/projects/1000/tasks/first.xml'
      assert Task.element_path(1000, :project_id => 1000) === '/projects/1000/tasks/1000.xml'
    end
  end
    
end