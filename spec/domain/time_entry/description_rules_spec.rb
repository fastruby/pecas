require "rails_helper"

describe TimeEntry::DescriptionRules do
  context "internal_employee rules" do
    describe "#valid?" do
      it "will pass if there is a Jira ticket reference" do
        validator = TimeEntry::DescriptionRules.new("[OSS-136]: added bug label")
        expect(validator.valid?).to eql(true)

        validator = TimeEntry::DescriptionRules.new("Added bug label OSS-136")
        expect(validator.valid?).to eql(true)

        validator = TimeEntry::DescriptionRules.new("OSS-136 added bug label")
        expect(validator.valid?).to eql(true)
      end

      it "will pass if there is a url reference" do
        validator = TimeEntry::DescriptionRules.new("http://www.example.com added bug label")
        expect(validator.valid?).to eql(true)

        validator = TimeEntry::DescriptionRules.new("Added bug http://www.example.com label")
        expect(validator.valid?).to eql(true)

        validator = TimeEntry::DescriptionRules.new("[http://www.example.com] added bug label")
        expect(validator.valid?).to eql(true)
      end

      it "will pass if there is #calls tag" do
        validator = TimeEntry::DescriptionRules.new("#calls added bug label")
        expect(validator.valid?).to eql(true)

        validator = TimeEntry::DescriptionRules.new("Added bug label #calls")
        expect(validator.valid?).to eql(true)

        validator = TimeEntry::DescriptionRules.new("[#calls] added bug label")
        expect(validator.valid?).to eql(true)
      end

      it "will fail if too short" do
        validator = TimeEntry::DescriptionRules.new("[OSS-136]: added")
        expect(validator.valid?).to eql(false)

        validator = TimeEntry::DescriptionRules.new("http://www.example.com added")
        expect(validator.valid?).to eql(false)

        validator = TimeEntry::DescriptionRules.new("#calls added")
        expect(validator.valid?).to eql(false)
      end

      it "will fail without a reference" do
        validator = TimeEntry::DescriptionRules.new("added bug label for ticket #136")
        expect(validator.valid?).to eql(false)
      end
    end
  end
end
