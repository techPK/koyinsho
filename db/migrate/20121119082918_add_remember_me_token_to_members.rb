class AddRememberMeTokenToMembers < ActiveRecord::Migration
  def change
    add_column :members, :remember_me_token, :string, :default => nil
    add_column :members, :remember_me_token_expires_at, :datetime, :default => nil
    add_index :members, :remember_me_token
  end
end
