class AddIndexToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :index, :integer
  end

  def self.down
    remove_column :products, :index
  end
end
