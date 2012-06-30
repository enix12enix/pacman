class Account
  include Mongoid::Document
  
  field :username, :type => String
  field :password, :type => String
  field :active, :type => Boolean, :default => true
  field :used, :type => Boolean, :default => false
  
  belongs_to :environment
  belongs_to :accounttype
  
  validates_presence_of :username, :password
  
end