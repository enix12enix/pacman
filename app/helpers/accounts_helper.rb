module AccountsHelper
  
  def environments
    Environment.all.to_a
  end
  
end
