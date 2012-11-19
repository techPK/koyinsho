class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :username,         :default => nil # if you use another field as a username, for example email, you can safely remove this field.
      t.string :email,            :null => false # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil
      t.string :roles,            :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end