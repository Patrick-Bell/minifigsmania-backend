class NewslettersController < ApplicationController
  before_action :set_newsletter, only: %i[ show update destroy ]
  before_action :set_current_user

  # GET /newsletters
  def index
    @newsletters = Newsletter.all

    render json: @newsletters
  end

  # GET /newsletters/1
  def show
    render json: @newsletter
  end

  # POST /newsletters
  def create
    @newsletter = Newsletter.new(newsletter_params)

    if @newsletter.save
      render json: @newsletter, status: :created, location: @newsletter
    else
      render json: @newsletter.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /newsletters/1
  def update
    if @newsletter.update(newsletter_params)
      render json: @newsletter
    else
      render json: @newsletter.errors, status: :unprocessable_entity
    end
  end

  # DELETE /newsletters/1
  def destroy
    @newsletter.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newsletter
      @newsletter = Newsletter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def newsletter_params
      params.require(:newsletter).permit(:email)
    end
end
