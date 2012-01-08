class ProductsController < ApplicationController

  def new
    @title = "Add product"
  end

  def show
    @product = Product.find(params[:id])
  end

  def index
   @title = "All products"
   @products = Product.all
  end
end
