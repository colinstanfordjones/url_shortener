class Api::UrlsController < Api::BaseController
  before_action :set_url, only: %i[ update destroy ]

  # POST /api/urls
  # POST /api/urls.json
  def create
    @url = Url.new(url_params.merge({user: current_user}))

    if @url.save
      render_jsonapi_response(@url)
    else
      render json: {errors: @url.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/urls/1
  # PATCH/PUT /api/urls/1.json
  def update
    if valid_user && @url.update(url_params)
      render_jsonapi_response(@url)
    else
      if valid_user
        render json: {errors: @url.errors}, status: :unprocessable_entity
      else
        render json: {errors: "unauthorized"}, status: :unauthorized 
      end
    end
  end

  # DELETE /api/urls/1
  # DELETE /api/urls/1.json
  def destroy
    if valid_user && @url.destroy
      render json: {success: true}, status: :ok
    else
      if valid_user
        render json: {errors: @url.errors}, status: :unprocessable_entity
      else
        render json: {errors: "unauthorized"}, status: :unauthorized 
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def url_params
      params_syms = %I[
        endpoint
        slug
        expiration
      ]

      params.require(:url).permit(*params_syms)
    end

    def valid_user
      @url.user_id == current_user.id
    end
end
