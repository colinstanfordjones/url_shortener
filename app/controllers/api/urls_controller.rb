class Api::UrlsController < ApplicationController
  before_action :set_url, only: %i[ show update destroy ]

  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    if @url.save
      render :show, status: :created, location: @url
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    if @url.update(url_params)
      render :show, status: :ok, location: @url
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def url_params
      params.fetch(:url, {})
    end
end
