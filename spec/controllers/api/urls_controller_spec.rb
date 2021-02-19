require "rails_helper"

RSpec.describe Api::UrlsController, type: :request do
  let (:user) { create_user }
  let (:user_adv) { create_user }
  let (:slug) { "test" }
  let (:endpoint) { "https://google.com" }

  context "when creating a new url" do
    context "logged in" do
      before do
        login_with_api(user)
        post "/api/urls/", headers: {
          'Authorization': response.headers['Authorization']
        }, params: {
          url: {
            endpoint: endpoint,
            slug: slug,
            expiration: Time.now
          }
        }
      end

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns the url object' do
        expect(json['url']['endpoint']).to eq(endpoint)
      end

      context 'duplicate slug' do
        before do
          login_with_api(user)
          post "/api/urls/", headers: {
            'Authorization': response.headers['Authorization']
          }, params: {
            url: {
              endpoint: endpoint,
              slug: slug
            }
          }
        end
  
        it 'returns 422' do
          expect(response.status).to eq(422)
        end
  
        it 'returns the url object' do
          expect(json['errors']['slug']).to eq(["has already been taken"])
        end
      end
    end

    context "not logged in" do
      before do
        post "/api/urls/", params: {
          url: {
            endpoint: endpoint
          }
        }
      end

      it 'returns 401' do
        expect(response.status).to eq(401)
      end
    end
  end

  context "when destroying a url" do
    context "logged in" do
      let (:url) { create_url(user, endpoint) }
      before do
        login_with_api(user)
        delete "/api/urls/#{url.id}", headers: {
          'Authorization': response.headers['Authorization']
        }
      end

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns the url object' do
        expect(json['success']).to eq(true)
      end
    end

    context 'from different user' do
      let (:url) { create_url(user, endpoint) }
      before do
        login_with_api(user_adv)
        delete "/api/urls/#{url.id}", headers: {
          'Authorization': response.headers['Authorization']
        }
      end

      it 'returns 401' do
        expect(response.status).to eq(401)
      end

      it 'returns the url object' do
        expect(json['errors']).to eq("unauthorized")
      end
    end

    context "not logged in" do
      let (:url) { create_url(user, endpoint) }
      before do
        delete "/api/urls/#{url.id}"
      end

      it 'returns 401' do
        expect(response.status).to eq(401)
      end
    end
  end
end
