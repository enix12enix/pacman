class Environment
  include Mongoid::Document
  
  field :name, :type => String
  field :domain, :type => String
  
  validates_presence_of :name, :domain
  validates_uniqueness_of :name, :domain
  
end