require "freckle"

class FreckleService
  attr_reader :client

  def initialize
    @client ||= Freckle::Client.new(token: ENV["FRECKLE_TOKEN"])
  end

  def import_entries(start_date, end_date)
    result = client.get_entries(from: start_date, to: end_date)
    save_entries_for(result)

    if result.try(:last_page)
      last_page = result.last_page.match(/page=(\d+)/)[1].to_i
      [2..last_page].each do |page|
        result = client.get_entries(from: start_date, to: end_date, page: page)
        save_entries_for(result)
      end
    end
  end

  private

  def save_entries_for(result)
    result.each do |entry|
      e1 = Entry.find_or_create_by(id: entry.id)
      e1.update_columns(
        description: entry.description,
        minutes:     entry.minutes,
        date:        entry.date,
        user_id:     entry.user.id,
        project_id:  entry.project.id
      )
    end
  end
end
