class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!
  
  def index
    @result = Hash.new
    
    Environment.all.to_a.each do |env|
      latest_10_versions = Testscope.where("environment.name" => env.name, :created => {"$gte" => DateTime.current.prev_month}).distinct(:ver).sort_by {|ver|ver_to_i(ver)}.reverse.slice(0, 10)
      if latest_10_versions.empty?
        next
      end
      latest_ver = latest_10_versions[0]
      testscope_status = Testscope.where(:ver => latest_ver, "environment.name" => env.name).to_a.collect do |testscope|
        [testscope.testJobs.where(:status => "pass").count,
         testscope.testJobs.where(:status => "fail").count,
         testscope.testJobs.where(:status => "pending").count]
      end
      
      status = Hash.new do |h, key|
        h["latest_ver"] = testscope_status.inject do |first, last|
          [first[0] + last[0], first[1] + last[1], first[2] + last[2]]
        end
        h["latest_ver"] << latest_ver
      end
      
      status["pass_rate"] = Array.new
      latest_10_versions.each do |ver|
        testscopes = Testscope.where(:ver => ver, "environment.name" => env.name).to_a
        total = 0
        pass = 0
        testscopes.each do |ts|
          total += ts.testJobs.count
          pass += ts.testJobs.where(:status => "pass").count
        end
        if total == 0
          status["pass_rate"] << [0, ver]
        else
          status["pass_rate"] << [(pass.to_f/total.to_f).round(2), ver]
        end
      end
      
      @result[env.name] = status
      
    end  
  end
  
  private
  
  def ver_to_i(ver)
    items = Array.new
    ver.split('.').each_with_index do |item, index|
      if index > 0 and item.size == 1
        items << "0" + item
      else
        items << item
      end
    end
    items.join.to_i
  end
  
end
