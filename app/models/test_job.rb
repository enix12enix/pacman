class TestJob
  include Mongoid::Document
  
  field :platform, :type => String
  field :baseurl, :type => String
  field :message, :type => String
  field :status, :type => String, :default => "pending"
  field :checked, :type => Boolean, :default => false
  field :created, :type => Date, :default => Date.current
  field :browser, :type => String
  field :locale, :locale => String
  field :testbox, :type => String
  field :username, :type => String
  field :password, :type => String
  
  belongs_to :testscope
  belongs_to :instance
  embeds_one :testScript
  embeds_one :accounttype
  embeds_one :account
  
  validates_inclusion_of :status, :in => ["pending", "running", "pass", "fail", "stop"]

end