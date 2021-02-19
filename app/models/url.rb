class Url < ApplicationRecord
  include ERB::Util

  belongs_to :user

  before_validation :sanitize_endpoint, on: [:create, :update]
  before_validation :check_slug, on: [:create, :update]
  before_validation :valid_expiration, on: [:create, :update]

  validates :slug, :uniqueness => {:allow_blank => false}
  validates_format_of :slug, without: /api\//i, message: "Slug may not contain 'api/'" 

  def valid_expiration
    unless expiration.nil?
      errors.add(:expiration, 'must be a valid datetime') if ((DateTime.parse(expiration.to_s) rescue ArgumentError) == ArgumentError)
    end
  end

  def check_slug
    if slug.nil? || slug == ""
      self.slug = rand(36**16).to_s(36)
    end

    self.slug = ERB::Util.url_encode(slug)
  end

  def sanitize_endpoint
    # TODO make this more rubust.
    errors.add(:expiration, 'must contain an endpoint')if endpoint == "" || endpoint.nil?
    # self.endpoint = ERB::Util.url_encode(endpoint)
  end

  def active?
    expiration.nil? || Time.now < expiration  ? true : false
  end
end
