class SlugController < ActionController::Base
  def slug
    url = Url.find_by_slug(params[:slug])
  
    if !url.nil? && url.active?
      redirect_to url.url, status: 302
    else
      render :fourohfour, status: 404
    end 
  end
end