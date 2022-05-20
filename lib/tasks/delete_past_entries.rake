desc "Deletes entries older than the specified months ago"
task delete_past_entries: :environment do
  if ENV["MONTHS"].blank?
    puts "Please specify the number of months ago to delete with the MONTHS env variable. Example: `MONTHS=5 bundle exec rake delete_past_entries"
  else
    date = ENV["MONTHS"].to_i.months.ago
    puts "deleting entries older than #{date}"
    Entry.delete_older_than(date)
    puts "finished deleting past entries"
  end
end
