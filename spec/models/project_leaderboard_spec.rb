require 'rails_helper'

describe ProjectLeaderboard do
  describe ".calculate" do
    let!(:project) { create :project }

    context 'without entries' do
      it 'is not generating the leaderboard' do
        expect do
          ProjectLeaderboard.calculate
        end.to change(ProjectLeaderboard.where(total_minutes: 0), :count).by(1)
      end
    end

    context 'with entries' do
      let!(:entry) { create :entry, project: project }

      it 'is generating the leaderboard' do
        expect { ProjectLeaderboard.calculate }.to change(
          ProjectLeaderboard.where(total_minutes: 0),
          :count
        ).by(0)

        expect(ProjectLeaderboard.where(
          total_minutes: entry.minutes).count).to eq(1)
      end
    end
  end
end
