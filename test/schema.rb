ActiveRecord::Schema.define(:version => 0) do
  create_table :look_up_fields, :force => true do |t| 
    t.string :for_table 
    t.string :for_field 
    t.timestamps
  end  
  create_table :look_up_items, :force => true do |t| 
    t.string :look_up_text
    t.integer :look_up_field_id
    t.integer :position  
    t.timestamps
  end  
  create_table :dogs, :force => true do |t| 
    t.string :bark
    t.string :bite
    t.string :breed
  end 
  create_table :cats, :force => true do |t| 
    t.string :purr
  end 
end 
