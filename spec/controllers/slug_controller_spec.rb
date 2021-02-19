require "rails_helper"

RSpec.describe SlugController, type: :request do
  let (:user) { create_user }
  let (:endpoint) { 'https://example.com' }
  let (:url) { create_url(user, endpoint) }
  let (:expired_url) { create_expired_url(user, endpoint) }

  context "valid slug" do
    before do
      get "/#{url.slug}"
    end

    it 'returns 302' do
      expect(response.status).to eq(302)
    end

    it 'redirects' do
      response.should redirect_to endpoint
    end
  end

  context "invalid slug" do
    before do
      get '/invalid' 
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context "expired slug" do
    before do
      get "/#{expired_url.slug}"
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end
end
