class TestScriptsController < ApplicationController
  
  def index
    render 'index'
  end
  
  def edit
    @testscript = TestScript.find(params[:id])
    respond_to do |format|
      format.html {render 'index'}
      format.js {render 'edit', :locals => {:title => 'Edit Test Script'}}
    end
  end
  
  def by_category
    @testscripts = TestScript.where(:category_id => params[:id]).to_a
    render 'index'
  end
  
  def update
    @testscript = TestScript.find(params[:id])
    if @testscript.update_attributes(params[params[:type]])
      flash.now[:notice] = 'Update successful'
    else
      flash.now[:error] = @testscript.errors.full_messages.join(', ')
    end
    @testscripts = TestScript.where(:category_id => @testscript.category.id).to_a
    render 'index'
  end
  
  def destroy
    @testscript = TestScript.find(params[:id])
    @testscript.destroy
    flash.now[:notice] = 'Delete successful'
    respond_to do |format|
      format.js
    end
  end
  
end
