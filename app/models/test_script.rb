class TestScript
  include Mongoid::Document
  
  field :name, :type => String
  field :path, :type => String
  field :devtest, :type => String
  field :active, :type => Boolean, :default => true
  field :multiplethread, :type => Boolean, :defalut => true
  
  belongs_to :platform
  belongs_to :category
  has_and_belongs_to_many :locales, inverse_of: nil
  has_and_belongs_to_many :accounttypes, inverse_of: nil
  
  validates_uniqueness_of :name
  validates_presence_of :name, :path
end