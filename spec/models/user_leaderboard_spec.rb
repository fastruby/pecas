require "rails_helper"

describe UserLeaderboard do
  include ActiveSupport::Testing::TimeHelpers

  describe ".with_logged_minutes" do
    let!(:user) { create :user }

    context "user has entry with 0 minutes" do
      let!(:entry) { create :entry, user: user, minutes: 0 }

      it "is not generating the leaderboard" do
        expect do
          UserLeaderboard.calculate
        end.to change(UserLeaderboard.with_logged_minutes, :count).by(0)
      end
    end

    context "with entries" do
      let!(:entry) { create :entry, user: user }

      it "is generating the leaderboard" do
        expect { UserLeaderboard.calculate }.to change(
          UserLeaderboard.with_logged_minutes,
          :count
        ).by(1)

        expect(UserLeaderboard.where(
          total_minutes: entry.minutes).count).to eq(1)
      end
    end
  end

  describe ".calculate" do
    let!(:user) { create :user }

    context "without entries" do
      it "is not generating the leaderboard" do
        expect do
          UserLeaderboard.calculate
        end.to change(UserLeaderboard.where(total_minutes: 0), :count).by(2)
      end
    end

    context "with entries" do
      let!(:entry) { create :entry, user: user }

      it "is generating the leaderboard" do
        expect { UserLeaderboard.calculate }.to change(
          UserLeaderboard.where(total_minutes: 0),
          :count
        ).by(1)

        expect(UserLeaderboard.where(
          total_minutes: entry.minutes).count).to eq(1)
      end
    end
  end
end
