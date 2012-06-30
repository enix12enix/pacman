class Accounttype
  include Mongoid::Document
  
  field :name, :type => String
  
  validates_uniqueness_of :name, :case_sensitive => false
  
end