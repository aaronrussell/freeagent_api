require 'test_helper'

class TaskTest < Test::Unit::TestCase
  
  context "Task class" do
    should "have correct collection path" do
      assert_equal '/projects/1000/tasks.xml', Task.collection_path(:project_id => 1000)
    end
    should "have correct element path" do
      assert_equal '/projects/1000/tasks/first.xml', Task.element_path(:first, :project_id => 1000)
      assert_equal '/projects/1000/tasks/1000.xml', Task.element_path(1000, :project_id => 1000)
    end
  end
  
  context "Tasks" do
    setup do
      @tasks = Task.find :all, :params => {:project_id => 17820}
    end
    should "return an array" do
      assert @tasks.is_a? Array
    end
    should "return Tasks" do
      assert_equal 7, @tasks.size
      assert @tasks.first.is_a? Task
    end
  end
  
  context "Task" do
    setup do
      @task = Task.find 13161, :params => {:project_id => 17820}
    end
    should "return a Invoice" do
      assert @task.is_a? Task
    end
    should "update and save" do
      @task.name = 'Development'
      assert @task.save
    end
    should "be destroyed" do
      assert @task.destroy
    end
  end
  
  #TODO - Add test for invalid resource
  # Need support from fakeweb in order to achieve this
  
  context "New Task" do
    setup do
      params = {
        :project_id => '17820',
        :name       => 'Creative design'
      }
      @task = Task.new params
    end
    should "validate and save" do
      assert @task.save_with_validation
    end
  end
    
end