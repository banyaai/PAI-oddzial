class AddAmountSentToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :amount_sent, :integer
  end

  def self.down
    remove_column :products, :amount_sent
  end
end
