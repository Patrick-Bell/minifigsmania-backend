class ImagesController < ApplicationController
    before_action :set_image, only: %i[ show update destroy ]
    before_action :authorize_admin, only: [:create, :destroy, :update]

  
    # GET /events
    def index
      @images = Image.all
  
      render json: @images
    end
  
    # GET /events/1
    def show
      render json: @images
    end
  
   # POST /images
   def create
    if params[:images].present? && params[:images][:files].present?
      uploaded_images = []
  
      begin
        params[:images][:files].each do |uploaded_file|
          cloudinary_response = Cloudinary::Uploader.upload(uploaded_file)
          @image = Image.new(
            url: cloudinary_response["secure_url"],
            product_id: params[:images][:product_id]
          )
  
          if @image.save
            uploaded_images << @image
          else
            render json: @image.errors, status: :unprocessable_entity and return
          end
        end
        render json: uploaded_images, status: :created
      rescue => e
        # Log the error to server logs
        Rails.logger.error("Error uploading image: #{e.message}")
        render json: { error: "Internal server error" }, status: :internal_server_error
      end
    else
      render json: { error: "No files uploaded" }, status: :unprocessable_entity
    end
  end
  

  
    # PATCH/PUT /events/1
    def update
      if @image.update(image_params)
        render json: @image
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /events/1
    def destroy
      @image.destroy!
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_image
        @image = Image.find(params.require(:id))
      end
  
      # Only allow a list of trusted parameters through.
      def image_params
        params.expect(event: [ :url, :product_id ])
      end


  end
  