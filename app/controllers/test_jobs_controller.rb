class TestJobsController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:pick_up, :update_result, :watch, :watch_completed]
  
  def check_me
    @job = TestJob.find(params[:id])
    @job.status = "pass"
    @job.checked = true
    if @job.save
      respond_to do |format|
        format.js {render 'checkme'}
      end
    else
      flash[:error] = "Failed to update"
    end
  end
  
  def new_watch_me
    @job = TestJob.find(params[:id])
    @testscope = @job.testscope
    respond_to do |format|
      format.js {render 'watchme', :locals => {:title => "Select Test Box to run"}}
    end
  end
  
  def watch_me
    @job = TestJob.find(params[:test_job][:id])
    if @job.update_attributes(:testbox => Box.find(params[:test_job][:testbox]).ip)
      flash[:notice] = "Please login to #{@job.testbox} to watch the test"
      redirect_to testscope_url(@job.testscope)
    else
      flash.now[:error] = @job.errors.full_messages.join(', ')
      redirect_to testscope_url(@job.testscope)
    end
    
  end
  
  def watch
    @job = TestJob.first(:conditions => {:testbox => request.remote_ip, :status => "fail"})
    unless @job.nil?
      render :xml => @job
      @job.testbox = nil
      @job.save!
    else
      render :nothing => true, :status => 404
    end
  end
  
  def pick_up 
    @job = TestJob.first(:conditions => {:platform => params[:platform], "testScript.multiplethread" => object_to_boolean(params[:multiplethread]), :status => "pending", :created => {"$gte" => Date.current - 1, "$lte" => Date.current}})
    unless @job.nil?
      @job.status = "running"
      instance = Instance.where(:active => rue, :ip => request.remote_ip)
      render :nothing => true, :status => 403 and return if instance.nil?
      @job.instance = instance
      unless @job.accounttype.nil?
        account = Account.where(:active => true, :used => false, :environment_id => @job.testscope.environment.id, :accounttype_id => @job.accounttype.id).to_a.sample(1)[0]
        if  account.nil?
          render :nothing => true, :status => 404 and return
        else
          account.used = true
          puts @job.attributes
          @job.account = account
          @job.username = account.username
          @job.password = account.password
          account.save!
          Delayed::Job.enqueue(AccountJob.new(account.id), :run_at => 10.minutes.from_now)
        end
      end
      @job.save!
      Delayed::Job.enqueue(TestjobJob.new(@job.id), :run_at => 10.minutes.from_now)
      render :xml => @job
    else
      render :nothing => true, :status => 404
    end
  end
  
  def update_result
    job = TestJob.find(params[:job_id])
    account = Account.find(params[:account_id])
    unless account.nil?
      account.update_attributes(:used => false)
    end
    if @job.update_attributes(:message => params[:message], :status => params[:status])
      render :text => "OK"
    else
      render :nothing => true, :status => 404
    end
  end
  
  private
  
  def object_to_boolean(value)
    return [true, "true", 1, "1", "T", "t"].include?(value.class == String ? value.downcase : value)
  end
  
end
