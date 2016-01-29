# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

env_file = "#{Rails.root}/db/seeds/#{Rails.env}.rb"
if File.exists?(env_file)
  puts "✨ Seeding with #{env_file} ✨"
  require env_file
  puts "✨✨✨ Done! 😃🍻 ✨✨✨"
end
