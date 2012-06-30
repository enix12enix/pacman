require "enumerator"

module TestscopesHelper
  
  def progress_bar_value(testscope)
    total = testscope.testJobs.count
    if total == 0
      [0, 0]
    else
      failed = testscope.testJobs.where(:status => "fail").count
      pass = testscope.testJobs.where(:status => "pass").count
      [pass*100/total, failed*100/total]
    end
  end
  
  def check_me_btn(job)
    if job.status == "fail"
      content_tag(:small, link_to("Check Me", checkme_path(job), :confirm => "Are you sure?", :remote => true, :method => "put"), :class => "normal")
    end
  end
  
  def watch_me_btn(job)
    if job.status == "fail" and job.testbox.nil?
      content_tag(:small, link_to("Watch Me", newwatchme_path(job), :remote => true), :class => "normal")
    end
  end
  
  def to_test_job(job)
    if job.status == "fail" or job.checked
      link_to "javascript:void(0)" do
        content_tag(:h4, "#{job.testScript.name} - #{job.locale}#{test_job_account(job)}#{test_job_ip(job)}#{test_job_checked(job)}", :class => job.status)
      end
    else
      content_tag(:h4, "#{job.testScript.name} - #{job.locale}#{test_job_account(job)}#{test_job_ip(job)}", :class => job.status)
    end
  end
  
  def status_btn(testscope)
    
    if testscope.testJobs.where(:status => "stop").exists?
      link_to testscope_restart_path(testscope), :method => "put" do
        content_tag(:span, nil, :class => "ui-icon ui-icon-play")
      end
    else
      unless testscope.testJobs.where(:status => "pending").exists?
        link_to testscope_retest_path(testscope), :method => "put" do
          content_tag(:span, nil, :class => "ui-icon ui-icon-eject")
        end
      else
        link_to testscope_pause_path(testscope), :method => "put" do
          content_tag(:span, nil, :class => "ui-icon ui-icon-pause")
        end
      end
    end  
  end
  
  private
  
  def test_job_checked(job)
    if job.checked
      " - Mannually Checked"
    else
      ""
    end
  end
  
  def test_job_ip(job)
    if job.instance.nil?
      ""
    else
      " - #{job.instance.ip}"
    end
  end
  
  def test_job_account(job)
    unless job.username.nil? or job.password.nil?
      " - " + job.username + " - " + job.password
    else
      ""
    end
  end
  
end
