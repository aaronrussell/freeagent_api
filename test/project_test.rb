require 'test_helper'

class ProjectTest < Test::Unit::TestCase
  
  def setup
    fake_it_all
    @projects = Project.find :all
    @project = Project.find 17820
  end
  
  context "Project class" do
    should "have correct collection path" do
      assert_equal Project.collection_path, '/projects.xml'
    end
    should "have correct element path" do
      assert_equal Project.element_path(:first), '/projects/first.xml'
      assert_equal Project.element_path(1), '/projects/1.xml'
    end
  end
  
  context "Projects" do
    should "return an array" do
      assert @projects.is_a? Array
    end
    should "return projects" do
      assert_equal 5, @projects.size
      assert @projects.first.is_a? Project
    end    
  end
  
  context "Project" do
    should "return a Project" do
      assert @project.is_a? Project
    end
  end
    
end