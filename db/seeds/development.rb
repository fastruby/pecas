require 'factory_girl'
FactoryGirl.find_definitions

user_1 = FactoryGirl.create :user, name: "Hans"
user_2 = FactoryGirl.create :user, name: "Franz"
user_3 = FactoryGirl.create :user, name: "Otto"

project_1 = Project.create name: 'OmbuLabs'
project_2 = Project.create name: 'OmbuShop'
project_3 = Project.create name: 'Freestyle'

days = [11.days.ago, 10.days.ago, 9.days.ago, 8.days.ago, 7.days.ago, 6.days.ago,
  5.days.ago, 4.days.ago, 3.days.ago, 2.days.ago, 1.days.ago, Date.today]

messages = [
  'Changed Spanish i18n strings, Added routes to avoid problems when logging in admin section.',
  'Removed comments, Added a login #statement for user #create',
  'Removed ssl_required from #admin #controller, I will ensure that with #nginx',
  'Added a #redirection to user sessions new for admin',
  'Added user #sessions #controller, to #override ssl_required line on :new I will ensure the right #protocol via #nginx #configuration',
  'Changed #dependencies.',
  'Removed #comments. #SSL is now supported',
  'Added cached #gems',
  'Corrected #deploy so that it deploys symlinks for assets',
  'Corrected #restarting mechanism, #bundle installation',
  'Corrected group name',
  'Replaced #passenger with #unicorn',
  'Added new controller and util method for current #subdomains',
  'Moved #calculator factories to calculator_factory file, added factory for negotation calc',
  'singleton removal fix for ipn controller',
  'Added #translation for shipping',
  'If the shipping method has a #calculator, add shipping type to the json for the checkout.',
  'Added NegotiableShipping #calculator.',
  'Added new #calculator to available calculators for creation.',
  'If #calculator is oca or negotiable, show Variable as label for cost.',
  'remove singleton usage for mercadopago service',
  'use rails logger to report #mercadopago error',
  'fix #mercadopago spec',
  'Removed Job and related code. Not used anymore in favor of #Intercom',
  'quickfix #controller spec and add comment',
  'adjust #mercadopago route',
  'add some comments and fixes to #mercadopago service',
  'show subscribe button only if a pending bill is available',
  'fix #route definition',
  'add country name to check_approval #method and #fix #tracking method',
  'prevent creating #mercadopago preference when accessing the user controller edit or update',
  'simplify #mercadopago pay button',
  'change link to create a #mercadopago #subscription'
]

10.times do
  days.each do |date|
    Entry.create(
      description: messages.sample,
      user: [user_1, user_2, user_3].sample,
      project: [project_1, project_2, project_3].sample,
      minutes: rand(10-360),
      date: date
    )
  end
end

Rake::Task["calc:leaderboards"].invoke
