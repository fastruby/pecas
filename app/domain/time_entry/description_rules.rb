class TimeEntry::DescriptionRules
  JIRA_REGEX = /(?:\s|^)([A-Z]+-[0-9]+)(?=\s|$)/

  def initialize(entry, ruleset = :internal_employee)
    @description = entry.description
    @ruleset = ruleset
  end

  def valid?
    return internal_employee() if @ruleset == :internal_employee
    false
  end

    private

    def has_word_count(length)
      return true if @description.split.size > length - 1
      false
    end

    def has_calls_tag
      @description.downcase.include?("#calls")
    end

    def has_url
      @description.downcase.include?("http")
    end

    def has_jira_ticket
      @description.gsub(/[\[\]\,\.]/, ' ').scan(JIRA_REGEX).any?
    end

    def internal_employee
      min_word_count = 4

      has_word_count(min_word_count) && (has_calls_tag() || has_url() || has_jira_ticket())
    end
end
