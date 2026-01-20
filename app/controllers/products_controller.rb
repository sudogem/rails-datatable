class ProductsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        # load records for the HTML view (adjust ordering/limit or add pagination as needed)
        @products = Product.includes(:category).order(created_at: :desc).limit(50)
      end
      format.json { render json: ProductsDatatable.new(view_context) }
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
