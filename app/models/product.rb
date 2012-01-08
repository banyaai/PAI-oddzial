class Product < ActiveRecord::Base
  attr_accessible :name, :prize, :amount, :amount_sent, :index

  validates :name, :presence => true
end
