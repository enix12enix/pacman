class TestjobJob < Struct.new(:id)
  
  def perform
    job = TestJob.find(id)
    if job.status == "running"
      job.update_attributes(:status => "fail", :message => "Test executed timeout 10 minutes")
    end
  end
  
end
