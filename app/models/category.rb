class Category
  include Mongoid::Document
  
  field :name, :type => String, :null => false
  
  has_many :testScripts
  
  validates_uniqueness_of :name
  
end