class AccountsController < ApplicationController
  
  
  def by_environment
    @accounts = Account.where(:environment_id => params[:id]).asc("accounttype.name")
    render "index"
  end
  
  def edit
    @account = Account.find(params[:id])
    respond_to do |format|
      format.js {render 'edit', :locals => {:title => 'Edit Test Account'}}
    end
  end
  
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    flash.now[:notice] = 'Delete successful'
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = 'Update successful'
    else
      flash[:error] = @account.errors.full_messages.join(', ')
    end
    redirect_to :action => "by_environment", :id => params[:account][:environment]
  end
  
  def new
    @account = Account.new
    respond_to do |format|
      format.js { render 'edit', :locals => {:title => "Create Test Account"}}
    end
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = 'Create successful'
      redirect_to :action => "by_environment", :id => @account.environment.id
    else
      flash.now[:error] = @account.errors.full_messages.join(', ')
      render 'index'
    end
    
  end
end
