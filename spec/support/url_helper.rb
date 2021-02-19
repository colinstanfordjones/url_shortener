require 'faker'
require 'factory_bot_rails'

module UrlHelpers
  def create_url(user, endpoint)
    FactoryBot.create(:url, 
			user: user,
      endpoint: endpoint
		)
  end

  def create_expired_url(user, endpoint)
    FactoryBot.create(:url, 
			user: user,
      endpoint: endpoint,
      expiration: 2.minutes.ago
		)
  end

	def build_url(user, endpoint)
    FactoryBot.create(:url, 
			user: user,
      endpoint: endpoint
		)
  end
end