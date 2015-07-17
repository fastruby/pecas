require 'rails_helper'

describe 'Reminder Mailer' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:receiver) { 'test@example.com' }
  let(:user)     { FactoryGirl.create(:user, name: 'Foo', email: receiver) }
  let(:email)    { Reminder.send_to(user) }

  it "should be set to be delivered to the email passed in" do
    expect(email).to deliver_to(receiver)
  end

  it "should have correct subject" do
    expect(email).to have_subject('Freckle Reminder')
  end

  it "should include link in body" do
    expect(email).to have_body_text('http://ombulabs.letsfreckle.com')
  end

  it "should include salutation in body" do
    expect(email).to have_body_text("Hello #{user.name},")
  end
end
