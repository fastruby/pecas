require "rails_helper"

describe TimeEntry::DescriptionRules do
  context "internal_employee rules" do
    describe "#valid?" do
      it "will pass if there is a Jira ticket reference" do
        entry = Entry.new(description: "[OSS-136]: added bug label")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)

        entry = Entry.new(description: "Added bug label OSS-136")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)

        entry = Entry.new(description: "OSS-136 added bug label")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)
      end

      it "will pass if there is a url reference" do
        entry = Entry.new(description: "http://www.example.com added bug label")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)

        entry = Entry.new(description: "Added bug http://www.example.com label")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)

        entry = Entry.new(description: "[http://www.example.com] added bug label")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)
      end

      it "will pass if there is #calls tag" do
        entry = Entry.new(description: "#calls added bug label")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)

        entry = Entry.new(description: "Added bug label #calls")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)

        entry = Entry.new(description: "[#calls] added bug label")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(true)
      end

      it "will fail if too short" do
        entry = Entry.new(description: "[OSS-136]: added")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(false)

        entry = Entry.new(description: "http://www.example.com added")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(false)

        entry = Entry.new(description: "#calls added")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(false)
      end

      it "will fail without a reference" do
        entry = Entry.new(description: "added bug label for ticket #136")
        validator = TimeEntry::DescriptionRules.new(entry)
        expect(validator.valid?).to eql(false)
      end
    end
  end
end
