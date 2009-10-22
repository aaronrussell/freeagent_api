require 'test_helper'

class ProjectTest < Test::Unit::TestCase
  
  fake_it_all
  
  context "Project class" do
    should "have correct collection path" do
      assert_equal '/projects.xml', Project.collection_path
    end
    should "have correct element path" do
      assert_equal '/projects/first.xml', Project.element_path(:first)
      assert_equal '/projects/1.xml', Project.element_path(1)
    end
  end
  
  context "Projects" do
    setup do
      @projects = Project.find :all
    end
    should "return an array" do
      assert @projects.is_a? Array
    end
    should "return projects" do
      assert_equal 5, @projects.size
      assert @projects.first.is_a? Project
    end
  end
  
  context "Project" do
    setup do
      @project = Project.find 17820
    end
    should "return a Project" do
      assert @project.is_a? Project
    end
    should "update and save" do
      @project.name = 'Rebranding project'
      assert @project.save
    end
    should "be destroyed" do
      assert @project.destroy
    end
  end
  
  #TODO - Add test for invalid resource
  # Need support from fakeweb in order to achieve this
  
  context "New Project" do
    setup do
      params = {
        :contact_id             => 27309,
        :name                   => 'Webdesign project',
        :payment_terms_in_days  => 30,
        :billing_basis          => 7.5,
        :budget_units           => 'Hours',
        :status                 => 'Active'
      }
      @project = Project.new  params
    end
    should "validate and save" do
      assert @project.save_with_validation
    end
  end
  
    
end