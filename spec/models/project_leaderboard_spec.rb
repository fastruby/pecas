require "rails_helper"

describe ProjectLeaderboard do
  describe ".calculate" do
    let!(:project) { create :project }

    describe ".with_logged_minutes" do
      context "user has entry with 0 minutes" do
        let!(:entry) { create :entry, project: project, minutes: 0 }

        it "is not generating the leaderboard" do
          expect do
            ProjectLeaderboard.calculate
          end.to change(ProjectLeaderboard.with_logged_minutes, :count).by(0)
        end
      end

      context "with entries" do
        let!(:entry) { create :entry, project: project }

        it "is generating the leaderboard" do
          expect { ProjectLeaderboard.calculate }.to change(
            ProjectLeaderboard.with_logged_minutes,
            :count
          ).by(1)

          expect(ProjectLeaderboard.where(
            total_minutes: entry.minutes).count).to eq(1)
        end
      end
    end


    context "without entries" do
      it "is not generating the leaderboard" do
        expect do
          ProjectLeaderboard.calculate
        end.to change(ProjectLeaderboard.where(total_minutes: 0), :count).by(2)
      end
    end

    context "with entries" do
      let!(:entry) { create :entry, project: project }

      it "is generating the leaderboard" do
        expect { ProjectLeaderboard.calculate }.to change(
          ProjectLeaderboard.where(total_minutes: 0),
          :count
        ).by(1)

        expect(ProjectLeaderboard.where(
          total_minutes: entry.minutes).count).to eq(1)
      end
    end
  end
end
