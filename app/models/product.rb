class Product < ActiveRecord::Base
  attr_accessible :name, :price, :released_on, :category
  
  belongs_to :category
end
