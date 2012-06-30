class User
  include Mongoid::Document

  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  
  ## Database authenticatable
  field :email,              :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  ## Rememberable
  field :remember_created_at, :type => Time
  
  field :admin, :type => Boolean, :default => false
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /@ea.com$/, :message => "Only EA Member can be allowed"
  attr_accessible :email, :password, :password_confirmation, :remember_me

end
