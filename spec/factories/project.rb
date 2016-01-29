FactoryGirl.define do
  factory :project do
    sequence(:name) {|n| "project_#{n}"}
  end
end
