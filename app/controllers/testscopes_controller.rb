require 'net/http'

class TestscopesController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:create]
  
  def index
    @date = DateTime.current
    @testscopes = Testscope.where(:created  => {"$gte" => @date.to_date,
                                                "$lt" => @date.to_date + 1})
                           .desc("created")                               
  end
  
  def show
    @testscope = Testscope.find(params[:id])
  end
  
  def search
    @date = DateTime.strptime(params[:created], "%m/%d/%Y")
    @testscopes = Testscope.where(:created  => {"$gte" => @date, 
                                                "$lt" => @date + 1})
                           .desc("created") 
    render 'index'
  end
  
  def create
    category = Category.find(params[:category])
    env = Environment.find(params[:environment])
    ver = get_ver(env)
    if ver.nil?
      flash.now[:error] = "Unable to create testscope. #{env.name} maybe down."
      render 'index' and return
    end
    testscope = Testscope.new(:name => category.name,
                              :ver => ver,
                              :environment => env,
                              :browser => Browser.find(params[:browser]))
    unless testscope.save
      flash.now[:error] = @testscript.errors.full_messages.join(', ')
      render 'index' and return
    end
    category.testScripts.where(:active => true).each do |ts|
      ts.locales.each do |locale|
        if ts.accounttypes.count == 0
          testscope.testJobs.create!(:testScript => ts,
                                     :locale => locale.sitecode,
                                     :testscope => testscope,
                                     :baseurl => build_base_url(testscope.environment, locale),
                                     :browser => testscope.browser.name,
                                     :platform => ts.platform.name)           
        else
          ts.accounttypes.each do |acc_type|
            if acc_type.name =~ /club/ and locale.sitecode =~ /de|fr/
              next
            end
            testscope.testJobs.create!(:testScript => ts,
                                       :locale => locale.sitecode,
                                       :accounttype => acc_type,
                                       :testscope => testscope,
                                       :baseurl => build_base_url(testscope.environment, locale),
                                       :browser => testscope.browser.name,
                                       :platform => ts.platform.name
           )
          end
        end
      end
    end
    flash[:notice] = "Create Successful"
    redirect_to testscopes_url
  end
  
  def retest
    @testscope = Testscope.find(params[:testscope_id])
    @testscope.testJobs.where(:status => "fail").each do |job|
      job.status = "pending"
      job.account = nil
      job.save!
    end
    flash[:notice] = "Retest #{@testscope.name}"
    redirect_to testscopes_url
  end
  
  def pause
    @testscope = Testscope.find(params[:testscope_id])
    @testscope.testJobs.where(:status => "pending").each do |job|
      job.status = "stop"
      job.save!
    end
    flash[:notice] = "Pause #{@testscope.name}"
    redirect_to testscopes_url
  end
  
  def restart
    @testscope = Testscope.find(params[:testscope_id])
    @testscope.testJobs.where(:status => "stop").each do |job|
      job.status = "pending"
      job.save!
    end
    flash[:notice] = "Restart #{@testscope.name}"
    redirect_to testscopes_url
  end
  
  private
  
  def get_ver(environment)
    begin
      ver = Net::HTTP.get(URI.parse("http://#{environment.domain}/version")).split(' ')[0]
      if ver =~ /\d+\.\d+\.\d+\.+\d+/
        ver
      end
    rescue
      
    end
  end
  
  def build_base_url(environment, locale)
    "http://#{locale.prefixurl}.#{environment.domain}"
  end
  
  
end
