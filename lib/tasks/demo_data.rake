namespace :demo_data do
  desc "Setup Demo data with development seeds"
  task setup: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    env_file = "#{Rails.root}/db/seeds/development.rb"
    require env_file if File.exists?(env_file)
  end
end
