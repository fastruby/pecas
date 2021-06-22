require "rails_helper"

describe LeaderboardController, type: :controller do
  let(:leaderboard) do
    assigns(:leaderboards).first
  end

  include ActiveSupport::Testing::TimeHelpers
  render_views

  describe "#projects" do
    it "renders successful" do
      get :projects

      expect(response.status).to eq(200)
    end

    context "leaderboard exists" do
      let(:project) { FactoryGirl.create :project }
      let!(:leaderboard_1) {
        FactoryGirl.create :project_leaderboard,
                           total_minutes: 1920,
                           start_date: Time.new(2015, 07, 6, 0, 0, 0).to_date,
                           end_date: Time.new(2015, 07, 12, 0, 0, 0).to_date,
                           project: project
      }
      let!(:leaderboard_2) {
        FactoryGirl.create :project_leaderboard,
                           total_minutes: 1740,
                           start_date: Time.new(2015, 07, 13, 0, 0, 0).to_date,
                           end_date: Time.new(2015, 07, 19, 0, 0, 0).to_date,
                           project: project
      }

      it "shows current leaderboard without params" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :projects

          expect(response.status).to   eq(200)
          expect((leaderboard.total_minutes / 60).to_i).to eq(29)
          expect(response.body).to     include("2015-07-13")
          expect(response.body).to     include("2015-07-19")
        end
      end

      context "project without logged minutes" do
        let!(:leaderboard_2) {
          FactoryGirl.create :project_leaderboard,
                             total_minutes: 0,
                             start_date: Time.new(2015, 07, 13, 0, 0, 0).to_date,
                             end_date: Time.new(2015, 07, 19, 0, 0, 0).to_date,
                             project: project
        }

        it "shows current leaderboard without params" do
          travel_to Time.new(2015, 07, 18, 0, 0, 0) do
            get :projects

            expect(response.status).to   eq(200)
            expect(leaderboard).to be_nil
            expect(response.body).to     include("2015-07-13")
            expect(response.body).to     include("2015-07-19")
          end
        end
      end

      it "shows current leaderboard for current week" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :projects, params: { weeks_ago: 0 }

          expect(response.status).to   eq(200)
          expect((leaderboard.total_minutes / 60).to_i).to eq(29)
          expect(response.body).to     include("2015-07-13")
          expect(response.body).to     include("2015-07-19")
        end
      end

      it "shows leaderboard from one week ago" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :projects, params: { weeks_ago: 1 }

          expect(response.status).to  eq(200)
          expect((leaderboard.total_minutes / 60).to_i).to eq(32)
          expect(response.body).to     include("2015-07-06")
          expect(response.body).to     include("2015-07-12")
        end
      end

      it "shows leaderboard from two weeks ago" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :projects, params: { weeks_ago: 2 }

          expect(response.status).to eq(200)
          within ".table-striped" do
            expect(response).not_to have_content("32")
            expect(response).not_to have_content("29")
          end
          expect(response.body).to     include("2015-06-29")
          expect(response.body).to     include("2015-07-05")
        end
      end
    end
  end

  describe "#users" do
    it "renders successful" do
      get :users

      expect(response.status).to eq(200)
    end

    context "leaderboard exists" do
      let(:user) { FactoryGirl.create :user }
      let!(:leaderboard_1) {
        FactoryGirl.create :user_leaderboard,
                           total_minutes: 1920,
                           start_date: Time.new(2015, 07, 6, 0, 0, 0).to_date,
                           end_date: Time.new(2015, 07, 12, 0, 0, 0).to_date,
                           user: user
      }
      let!(:leaderboard_2) {
        FactoryGirl.create :user_leaderboard,
                           total_minutes: 1740,
                           start_date: Time.new(2015, 07, 13, 0, 0, 0).to_date,
                           end_date: Time.new(2015, 07, 19, 0, 0, 0).to_date,
                           user: user
      }

      it "shows current leaderboard without params" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :users

          expect(response.status).to   eq(200)
          expect((leaderboard.total_minutes / 60).to_i).to eq(29)
          expect(response.body).to     include("2015-07-13")
          expect(response.body).to     include("2015-07-19")
        end
      end

      context "user without logged minutes" do
        let!(:leaderboard_2) {
          FactoryGirl.create :user_leaderboard,
                             total_minutes: 0,
                             start_date: Time.new(2015, 07, 13, 0, 0, 0).to_date,
                             end_date: Time.new(2015, 07, 19, 0, 0, 0).to_date,
                             user: user
        }

        it "does not show user" do
          travel_to Time.new(2015, 07, 18, 0, 0, 0) do
            get :users

            expect(response.status).to   eq(200)
            expect(response.body).not_to include(user.name)
            expect(response.body).to     include("2015-07-13")
            expect(response.body).to     include("2015-07-19")
          end
        end
      end

      it "shows current leaderboard for current week" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :users, params: { weeks_ago: 0 }

          expect(response.status).to   eq(200)
          expect((leaderboard.total_minutes / 60).to_i).to eq(29)
          expect(response.body).to     include("2015-07-13")
          expect(response.body).to     include("2015-07-19")
        end
      end

      it "shows leaderboard from one week ago" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :users, params: { weeks_ago: 1 }

          expect(response.status).to  eq(200)
          expect((leaderboard.total_minutes / 60).to_i).to eq(32)
          expect(response.body).to     include("2015-07-06")
          expect(response.body).to     include("2015-07-12")
        end
      end

      it "shows leaderboard from two weeks ago" do
        travel_to Time.new(2015, 07, 18, 0, 0, 0) do
          get :users, params: { weeks_ago: 2 }

          expect(response.status).to eq(200)
          within ".table-striped" do
            expect(response).not_to have_content("32")
            expect(response).not_to have_content("29")
          end

          expect(response.body).to     include("2015-06-29")
          expect(response.body).to     include("2015-07-05")
        end
      end
    end
  end
end
