FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "name_#{n}"}
    sequence(:email) {|n| "name_#{n}@example.com"}
    state { "active" }
  end
end
