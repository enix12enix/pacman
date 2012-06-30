module InstanceHelper
  
  def active_button(instance)
    content_tag :small, :class => instance.active ? 'active' : 'inactive' do
      link_to "Active", instance_set_status_path(instance), :id => "status_#{instance.id}", :method => "put", :remote => true 
    end
  end
  
  def last_24_hours_pass_rate(instance)
    pass = instance.testJobs.where(:created => {"$gte" => Date.current - 1, "$lte" => Date.current}, :status => "pass").count
    fail = instance.testJobs.where(:created => {"$gte" => Date.current - 1, "$lte" => Date.current}, :status => "fail").count
    if fail + pass > 0
      rate = pass*100 / (fail + pass)
      content_tag :h3, "#{rate.to_s}%", :style => "margin-left:230px;#{pass_rate_color(rate)}"
    end
  end
  
  private
  
  def pass_rate_color(rate)
    if rate >= 80
      "color:#7FBF4D"
    elsif rate >= 40 and rate <= 80
      "color:#FFAA00"
    else
      "color:#FF0000"
    end
  end
  
end
