# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


admin = User.create(:email => 'admin@ea.com', :password => 'welcome', :password_confirmation => 'welcome')
admin.admin = true
admin.save

Environment.create(:name => "Alpha", :domain => "alpha.pogo.com")
Environment.create(:name => "Beta", :domain => "pogobeta.com")
Environment.create(:name => "Prod", :domain => "pogo.com")

Browser.create(:name => "firefox")
Browser.create(:name => "ie")
Browser.create(:name => "chrome")

Locale.create(:sitecode => "us", :prefixurl => "www")
Locale.create(:sitecode => "uk", :prefixurl => "uk")
Locale.create(:sitecode => "de", :prefixurl => "de")
Locale.create(:sitecode => "fr", :prefixurl => "fr")

Platform.create(:name => "grinder")
Platform.create(:name => "ec2")

Accounttype.create(:name => "free")
Accounttype.create(:name => "club")
