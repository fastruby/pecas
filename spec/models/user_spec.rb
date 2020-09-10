require 'rails_helper'

describe User do
  include ActiveSupport::Testing::TimeHelpers

  describe '.send_reminders' do
    context 'two users without entries' do
      let!(:user_list) { create_list(:user, 2) }

      context 'weekday' do
        it 'sends reminders to users without entries from today' do
          expect(Reminder).to receive(:send_to).twice
            .and_return(double 'Mailer', deliver: true)

          travel_to Time.new(2016, 03, 23, 0, 0, 0) do
            User.send_reminders
          end
        end
      end

      context 'holiday in argentina' do
        before do
          stub_const("ENV", {"COUNTRY_CODE" => "ar"})
        end

        it 'does not send reminders' do
          expect(Reminder).not_to receive(:send_to)

          travel_to Time.new(2016, 03, 24, 0, 0, 0) do
            User.send_reminders
          end

          travel_to Time.new(2016, 06, 20, 0, 0, 0) do
            User.send_reminders
          end
        end
      end

      context 'holiday in argentina but country code is not set' do
        before do
          stub_const("ENV", {})
        end

        it 'sends reminders to users with entries' do
          expect(Reminder).to receive(:send_to).twice
            .and_return(double 'Mailer', deliver: true)

          travel_to Time.new(2016, 03, 24, 0, 0, 0) do
            User.send_reminders
          end
        end
      end

      context 'weekend' do
        it 'does not send reminders' do
          expect(Reminder).not_to receive(:send_to)

          travel_to Time.new(2016, 12, 10, 0, 0, 0) do
            User.send_reminders
          end

          travel_to Time.new(2016, 12, 11, 0, 0, 0) do
            User.send_reminders
          end
        end
      end
    end

    context 'single user with an entry' do
      let(:user)   { create(:user, name: 'foo', email: 'bar@example.com') }
      let!(:entry) { create(:entry, user_id: user.id) }

      it 'should not send reminder to user with an entry' do
        expect(Reminder).not_to receive(:send_to).with(user)

        User.send_reminders
      end
    end

    context 'disabled user' do
      let(:user) do
        create(:user, name: 'foo', email: 'bar@example.com', state: "disabled")
      end

      it 'should not send reminder to user with an entry' do
        expect(Reminder).not_to receive(:send_to).with(user)

        User.send_reminders
      end
    end
  end

  describe '#minutes_of_week' do
    let(:user)   { create(:user) }
    let!(:entry) { create(:entry, minutes: 1337, user_id: user.id) }

    it 'sums up the correct amount of minutes for user in current week' do
      expect(user.minutes_of_week(0)).to eq(entry.minutes)
    end

    context 'with entry from last week' do
      let!(:other_entry) { create(:entry, minutes: 10, user_id: user.id, date: 1.week.ago.beginning_of_week) }

      it 'does not sum up minutes from last week' do
        expect(user.minutes_of_week(1)).to eq(other_entry.minutes)
      end
    end
  end
end
