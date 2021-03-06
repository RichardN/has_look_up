# HasLookup
module HasLookUp

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_look_up( *field_or_fields )
      include HasLookUp::InstanceMethods
      field_or_fields.each do |f|
      LookUpField.find_or_create_by_for_table_and_for_field( self.table_name, f.to_s )       
        if self.column_names.include?( f.to_s )
          validates_presence_in_look_up( f )
        else
          raise ActiveRecord::UnknownAttributeError, "Column not found", caller
        end
      end
    end
    def validates_presence_in_look_up( *field_or_fields )
      self.validates_each field_or_fields do |record, attrib, value|
        look_up_field = LookUpField.find_by_for_table_and_for_field( self.table_name, attrib.to_s )
        record.errors.add(attrib, "cannot have the value #{value}") unless look_up_field.look_up_items.map( &:look_up_text ).include?( value )
      end
    end
  end

  module InstanceMethods
    def look_up_entries( field_name )
      LookUpField.find_by_for_table_and_for_field( self.class.table_name, field_name.to_s ).look_up_items.all( :order => 'position, look_up_text ASC' )
    end
    # Add instance methods here
  end

end

module LookUpFormOptionsHelper

  def look_up_select(object, method, options = {}, html_options = {} )
    collection_select(object, method, object.look_up_entries( method.to_s ), :look_up_text, :look_up_text, options = {}, html_options = {})
  end

end



ActiveRecord::Base.send(:include, HasLookUp)
ActionView::Helpers::FormOptionsHelper.send(:include, LookUpFormOptionsHelper )

%w{ models }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)  
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path 
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end 

