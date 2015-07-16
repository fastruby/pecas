# Configure the client before fetching data.
Dotenv.load

LetsFreckle.configure do
  account_host ENV['FRECKLE_ACCOUNT_HOST']
  username ENV['FRECKLE_USERNAME']
  token ENV['FRECKLE_TOKEN']
end
