class InstancesController < ApplicationController
  
  def index
    @instances = Instance.all.to_a
  end
  
  def new
    @instance = Instance.new
    respond_to do |format|
      format.html {render 'index'}
      format.js {render 'edit', :locals => {:title =>"Create Test Instance"}}
    end
  end
  
  def create
    @instance = Instance.new(params[:instance])
    if @instance.save
      flash[:notice] = 'Create successful'
    else
      flash[:error] = @instance.errors.full_messages.join(', ')
    end
    redirect_to instances_url
  end
  
  def set_status
    @instance = Instance.find(params[:instance_id])
    if @instance.active
      @instance.update_attribute(:active, false)
    else
      @instance.update_attribute(:active, true)
    end
    respond_to do |format|
      format.html {render 'index'}
      format.js {render 'set_status'}
    end
  end
  
  def destroy
    @instance = Box.find(params[:id])
    @instance.destroy
    flash.now[:notice] = 'Delete successful'
    respond_to do |format|
      format.js
    end
  end
  
end