class SlugController < ActionController::Base
  def slug
    url_encoded = ERB::Util.url_encode(params[:slug])
    url = Url.find_by_slug(url_encoded)

    if !url.nil? && url.active?
      redirect_to url.endpoint, status: 302
    else
      render :fourohfour, status: 404
    end 
  end
end