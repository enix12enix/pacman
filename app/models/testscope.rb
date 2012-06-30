class Testscope
  include Mongoid::Document
  
  field :name, :type => String
  field :ver, :type => String
  field :created, :type => DateTime, :default => DateTime.current
  
  embeds_one :environment
  embeds_one :browser
  has_many :testJobs, :dependent => :delete
  
end