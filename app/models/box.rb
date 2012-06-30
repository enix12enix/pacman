class Box
  include Mongoid::Document
  
  field :ip, :type => String
  field :active, :type => Boolean, :default => true
  
  validates_presence_of :ip
  validates_uniqueness_of :ip
  
end