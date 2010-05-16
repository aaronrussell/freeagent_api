require 'test_helper'

class UserTest < Test::Unit::TestCase
  
  fake_it_all
  
  context "User class" do
    should "have correct collection path" do
      assert_equal '/company/users.xml', User.collection_path
    end
    should "have correct element path" do
      assert_equal '/company/users/first.xml', User.element_path(:first)
      assert_equal '/company/users/1000.xml', User.element_path(1000)
    end
  end
  
  context "Users" do
    setup do
      @users = User.find :all
    end
    should "return an array" do
      assert @users.is_a? Array
    end
    should "return Users" do
      assert_equal 2, @users.size
      assert @users.first.is_a? User
    end
  end
  
  context "User" do
    setup do
      @user = User.find 11
    end
    should "return a User" do
      assert @user.is_a? User
    end
    should "update and save" do
      @user.email = 'olly@gmail.com'
      assert @user.save
    end
    should "be destroyed" do
      assert @user.destroy
    end
  end
  
  context "Finding User" do
    setup do
      @user = User.find_by_email('olly@gmail.com')
    end
    should "return a User" do
      assert @user.is_a? User
    end
    should "return the correct User" do
      assert_equal User.find(11), @user
    end
  end
  
  context "New User" do
    setup do
      params = {
          :first_name => 'John',
          :last_name  => 'Doe',
          :email      => 'jdoe@example.com',
          :role       => 'Owner',
          :password   => 'password',
          :password_confirmation => 'password'
      }
      @user = User.new params
    end
    should "validate and save" do
      assert @user.save_with_validation
    end
  end
    
end