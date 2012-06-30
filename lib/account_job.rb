class AccountJob < Struct.new(:account_id)
  
  def perform
    account = Account.find(account_id)
    if account.used
      account.update_attributes(:used => false)
    end
  end
  
end
