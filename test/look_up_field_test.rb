require File.dirname(__FILE__) + '/test_helper.rb'

class LookUpFieldTest < Test::Unit::TestCase 
  load_schema 
  def test_look_up_field
    assert_kind_of LookUpField, LookUpField.new 
  end 
end 
