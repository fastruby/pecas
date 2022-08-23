class TimeEntry::DescriptionRules
  JIRA_REGEX = /(?:\s|^)([A-Z]+-[0-9]+)(?=\s|$)/
  MIN_WORD_COUNT = 4
  KEYWORDS = ["#english", "english", "english class", "1:1", "one on one", "1-1", "end of week", "weekly call", "weekly meeting", "emails/slack", "email", "slack" "catch up", "catching up", "standup", "stand up", "check-in", "check in", "learning", "learn", "donut"]

  def initialize(entry, ruleset = :internal_employee)
    @description = entry.description
    @ruleset = ruleset
  end

  def valid?
    return internal_employee if @ruleset == :internal_employee
    false
  end

    private

    def has_word_count?
      if has_jira_ticket?
        @description.split.size > 1
      else
        @description.split.size > 0
      end
    end

    def has_calls_tag?
      @description.downcase.include?("#calls")
    end

    def has_url?
      @description.downcase.include?("http")
    end

    def has_keywords?
      !!(@description.downcase =~ Regexp.union(KEYWORDS))
    end

    # Removes square brackets and commas from the string before match as the
    #   "official" Jira regex won't match unless the jira id is preceeded by
    #   a space
    def has_jira_ticket?
      @description.gsub(/[\[\]\,\.]/, ' ').scan(JIRA_REGEX).any?
    end

    def internal_employee
      if has_keywords?
        has_word_count?
      else
        has_word_count? && (has_calls_tag? || has_url? || has_jira_ticket?)
      end
    end
end