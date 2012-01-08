class Product < ActiveRecord::Base
  attr_accessible :name, :prize, :amount

  validates :name, :presence => true
end
