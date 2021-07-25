FactoryBot.define do
  factory :project do
    sequence(:name) {|n| "project_#{n}"}
    enabled { true }
  end
end
