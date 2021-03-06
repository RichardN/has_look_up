require File.dirname(__FILE__) + '/test_helper.rb' 

class HasLookUpTest < Test::Unit::TestCase
  load_schema

  class Dog < ActiveRecord::Base
  end

  class Cat < ActiveRecord::Base
  end

  def setup
    load_schema
  end

  def teardown
  end

  def test_schema_has_loaded_correctly
    assert_equal [] , LookUpField.all
  end

  def test_look_up_fields_are_populated_en_mass
    Dog.has_look_up :bark, :bite
    assert_equal 2, LookUpField.all.size
    assert_equal [ "bark" , "bite" ], LookUpField.all.collect( &:for_field ).sort
    assert_equal [ "dogs" , "dogs" ], LookUpField.all.collect( &:for_table ).sort
  end

  def test_look_up_fields_are_populated_individually
    Dog.has_look_up :bark
    Dog.has_look_up :bite
    assert_equal 2, LookUpField.all.size
    assert_equal [ "bark" , "bite" ], LookUpField.all.collect( &:for_field ).sort
    assert_equal [ "dogs" , "dogs" ], LookUpField.all.collect( &:for_table ).sort
  end

  def test_multiple_invocations_only_add_one_item
    Dog.has_look_up :bark
    Dog.has_look_up :bark
    assert_equal 1, LookUpField.all.size
    assert_equal [ "bark" ], LookUpField.all.collect( &:for_field ).sort
    assert_equal [ "dogs" ], LookUpField.all.collect( &:for_table ).sort
  end

  def test_look_up_fields_collected_from_correct_tables
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    assert_equal 3, LookUpField.all.size
    assert_equal [ "bark" , "bite", "purr" ], LookUpField.all.collect( &:for_field ).sort
    assert_equal [ "cats", "dogs" , "dogs" ], LookUpField.all.collect( &:for_table ).sort
    assert_equal "purr", LookUpField.find_by_for_table('cats').for_field
  end

  def test_has_lookup_for_missing_field_raises_unknown_attribute_error
    assert_raise ActiveRecord::UnknownAttributeError do
      Cat.has_look_up :markings
    end  
  end

  def test_setting_value_to_value_not_in_lookup_should_raise_validation_error
    load_fixtures
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    assert_raise ActiveRecord::RecordInvalid do
      Dog.create!( :bark => "yap", :bite => "snap" )
    end  

  end

  def test_setting_value_to_value_in_other_lookup_category_should_raise_validation_error
    load_fixtures
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    assert_raise ActiveRecord::RecordInvalid do
      Dog.create!( :bark => "scar", :bite => "nip" )
    end  

  end


  def test_setting_value_to_value_in_lookup_should_not_validation_error
    load_fixtures
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    assert_nothing_raised ActiveRecord::RecordInvalid do
      Dog.create!( :bark => "yap", :bite => "nip" )
    end  
  end



end
