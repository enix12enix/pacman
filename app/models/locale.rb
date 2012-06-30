class Locale
  include Mongoid::Document
  
  field :sitecode, :type => String, :null => false
  field :prefixurl, :type => String, :null => false
  
  validates_uniqueness_of :sitecode, :case_sensitive => false
  validates_uniqueness_of :prefixurl, :case_sensitive => false
  
end