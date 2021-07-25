FactoryBot.define do
  factory :entry do
    description 'hello world'
    minutes 10
    date Date.today
  end
end
