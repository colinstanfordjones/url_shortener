class Url < ApplicationRecord
  belongs_to :user
  before_create :sanitize

  def generate_short_url
    rand(36**8).to_s(36)
  end

  def sanitize
    # TODO fix the http/s part here.
    sanitize_url = url.downcase.gsub(/(https?:\/\/)|(www\.)/,"")
    "http://#{sanitize_url}"
  end
end
