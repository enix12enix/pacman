class Platform
  include Mongoid::Document
  
  field :name, :type => String
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
end