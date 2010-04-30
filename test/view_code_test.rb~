require File.dirname(__FILE__) + '/test_helper.rb' 
require File.dirname(__FILE__) + '/../lib/has_look_up'
# Here's the helper file we need

require 'action_view/helpers/form_options_helper'


class HasLookUpTest < Test::Unit::TestCase
  load_schema

  include ActionView::Helpers::FormOptionsHelper
  include HasLookUp


  class Dog < ActiveRecord::Base
  end

  class Cat < ActiveRecord::Base
  end

  def setup
    load_schema
    load_fixtures
  end

  def test_empty_select
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    new_cat = Cat.new
    assert_equal collection_select( new_cat, :purr, [], :look_up_text, :look_up_text ), look_up_select( new_cat, :purr )
  end

  def test_missing_field_should_give_throw_undefined_method_on_nil
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    new_cat = Cat.new
    assert_raise NoMethodError do
      look_up_select( new_cat, :markings )
    end
  end


  def test_non_used_field_should_give_throw_undefined_method_on_nil
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    new_dog = Dog.new
    assert_raise NoMethodError do
      look_up_select( new_dog, :breed )
    end
  end

  def test_bark
    Dog.has_look_up :bark, :bite
    Cat.has_look_up :purr
    new_dog = Dog.new
    assert_equal %w( >yap< >growl< >woof< ), look_up_select( new_dog, :bark ).scan( />\w+</ )
  end


end
