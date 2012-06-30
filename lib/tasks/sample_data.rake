require "faker"

namespace :sampledata do
  
  desc "insert environment"
  task :env => :environment do |variable|
    Environment.delete_all
    Environment.new(:name => "Alpha", :domain => "alpha.pogo.com").save
    Environment.new(:name => "Beta", :domain => "pogobeta.com").save
    Environment.new(:name => "Prod", :domain => "pogo.com").save
  end
  
  desc "insert boxes"
  task :box => :environment do |variable|
    Box.delete_all
    5.times do |n|
      Box.new(:ip => "127.0.0.#{n}").save!
    end
  end
  
  desc "insert browser"
  task :browser => :environment do |variable|
    Browser.delete_all
    Browser.new(:name => "firefox").save!
    Browser.new(:name => "ie").save!
    Browser.new(:name => "chrome").save!
  end
  
  desc "insert test accounts"
  task :account => :environment do |variable|
    Account.delete_all
    Accounttype.delete_all
    Accounttype.new(:name => "free").save!
    Accounttype.new(:name => "club").save!
    Accounttype.new(:name => "facebook").save!
    accounttypes = Accounttype.all.to_a
    environments = Environment.all.to_a
    100.times do |n|
      Account.new(:username => Faker::Lorem.words(1)[0],
                  :password => Faker::Lorem.words(1)[0],
                  :environment => environments.sample(1)[0],
                  :accounttype => accounttypes.sample(1)[0]).save!
    end
  end
  
  desc "insert category"
  task :category => :environment do |variable|
    TestScript.delete_all
    Category.delete_all
    Category.new(:name => 'Game Test').save!
    Category.new(:name => 'Facebook App Test').save!
    Category.new(:name => 'Iwinchecker Test').save!
    Category.new(:name => 'Pogo Feature Test').save!
    Category.new(:name => 'CSR Test').save!
    Category.new(:name => 'All Game Page Test').save!
  end
  
  desc "insert game test"
  task :gametest => :environment do
    100.times do |n|
      name = Faker::Lorem.words(5).join
      path = Faker::Lorem.words(5).join
      devtest = Faker::Lorem.words(1)[0]
      locales = Locale.all.to_a
      acctypes = Accounttype.all.to_a
      t = GameTest.new(:name => name, 
                       :path => path, 
                       :devtest => devtest, 
                       :platform_id => Platform.first.id,
                       :category_id => Category.where(:name => "Game Test").first.id,
                       :multiplethread => false,
                       :locale_ids => [locales.sample(1)[0].id],
                       :accounttype_ids => [acctypes.sample(1)[0].id],
                       :gamepath => Faker::Lorem.words(5).join)
      t.save
    end
  end
  
  desc "insert testscript"
  task :testscript => :environment do |variable|
    TestScript.delete_all
    categories = Category.not_in(:name => ["Game Test"]).to_a
    platforms = Platform.all.to_a
    locales = Locale.all.to_a
    acctypes = Accounttype.all.to_a
    10.times do |n|
      name = Faker::Lorem.words(5).join
      path = Faker::Lorem.words(5).join
      devtest = Faker::Lorem.words(1)[0]
      t = TestScript.new(:name => name, 
                         :path => path, 
                         :devtest => devtest, 
                         :platform_id => platforms.sample(1)[0].id,
                         :category_id => categories.sample(1)[0].id,
                         :multiplethread => [true, false].sample(1)[0],
                         :locale_ids => [locales.sample(1)[0].id],
                         :accounttype_ids => [acctypes.sample(1)[0].id])
      t.save
    end
  end
  
  desc "insert testscopes and test jobs"
  task :testscope => :environment do |variable|
    Testscope.delete_all
    platforms = Platform.all.to_a
    environments = Environment.all.to_a
    locales = Locale.all.to_a
    accounttypes = Accounttype.all.to_a
    accounts = Account.all.to_a
    browsers = Browser.all.to_a
    instances = Instance.all.to_a
    15.times do |n|
      t = Testscope.new(:name => Faker::Lorem.words(5).join,
                        :ver => ["13.0.1.36", "12.1.6.7", "13.0.6.34", "13.1.5.8", "14.0.9.8"].sample(1)[0],
                        :environment => environments.sample(1)[0],
                        :browser => browsers.sample(1)[0])
      t.save
    end
    testscopes = Testscope.all.to_a
    testscripts = TestScript.all.to_a
    200.times do |n|
      t = testscopes.sample(1)[0]
      j = TestJob.new(:browser => t.browser.name,
                      :status =>["pending", "running", "pass", "fail"].sample(1)[0],
                      :locale => locales.sample(1)[0].sitecode,
                      :account => accounts.sample(1)[0],
                      :instance => instances.sample(1)[0],
                      :testScript => testscripts.sample(1)[0])
      if j.status == "fail"
        j.message = Faker::Lorem.sentences(10).join
      end
      t.testJobs << j
      t.save
    end
    t = Testscope.new(:name => Faker::Lorem.words(5).join,
                      :ver => "13.0.1.36",
                      :environment => environments.sample(1)[0],
                      :browser => browsers.sample(1)[0])
    t.save!
    10.times do |n|
      j = TestJob.new(:browser => t.browser.name,
                      :status =>["pass", "fail"].sample(1)[0],
                      :locale => locales.sample(1)[0].sitecode,
                      :account => accounts.sample(1)[0],
                      :instance => instances.sample(1)[0],
                      :testScript => testscripts.sample(1)[0])
      t.testJobs << j
      t.save
    end
    t = Testscope.new(:name => Faker::Lorem.words(5).join,
                      :ver => ["13.0.1.36", "12.1.6.7", "13.0.6.34", "13.1.5.8", "14.0.9.8"].sample(1)[0],
                      :environment => environments.sample(1)[0],
                      :browser => browsers.sample(1)[0])
    t.save!
    200.times do |n|
      j = TestJob.new(:browser => t.browser.name,
                      :status =>["pass", "stop", "fail", "pending", "running"].sample(1)[0],
                      :locale => locales.sample(1)[0].sitecode,
                      :account => accounts.sample(1)[0],
                      :instance => instances.sample(1)[0],
                      :testScript => testscripts.sample(1)[0])
      t.testJobs << j
      t.save
    end
  end 
end
