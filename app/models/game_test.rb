class GameTest < TestScript
  include Mongoid::Document
  
  field :gamepath, :type => String
  
  validates_uniqueness_of :gamepath
  validates_presence_of :gamepath
end