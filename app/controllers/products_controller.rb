class ProductsController < ApplicationController

  respond_to :json

  def new
    @title = "Add product"
  end

  def show
    @product = Product.find(params[:id])
  end

  def index
  # @title = "All products"
  # @products = Product.all
    respond_with to_client
  end

  def to_client
    Product.all.map { |p| {"name" => p.name, "prize" => p.prize, "amount" => nil} }
  end
end
