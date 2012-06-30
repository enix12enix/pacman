class BoxesController < ApplicationController
  
  def index
    @boxes = Box.all.to_a
  end
  
  def edit
    @box = Box.find(params[:id])
    respond_to do |format|
      format.html {render 'index'}
      format.js {render 'edit', :locals => {:title => 'Edit Test Box'}}
    end
  end
  
  def update
    @box = Box.find(params[:id])
    if @box.update_attributes(params[:box])
      flash[:notice] = 'Update successful'
    else
      flash[:error] = @box.errors.full_messages.join(', ')
    end
    redirect_to boxes_url
  end
  
  def destroy
    @box = Box.find(params[:id])
    @box.destroy
    flash.now[:notice] = 'Delete successful'
    respond_to do |format|
      format.js
    end
  end
  
  def new
    @box = Box.new
    respond_to do |format|
      format.html {render 'index'}
      format.js {render 'edit', :locals => {:title =>"Create Test Box"}}
    end
  end
  
  def create
    @box = Box.new(params[:box])
    if @box.save
      flash[:notice] = 'Create successful'
    else
      flash[:error] = @box.errors.full_messages.join(', ')
    end
    redirect_to boxes_url
  end
  
end
