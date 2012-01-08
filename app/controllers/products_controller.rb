class ProductsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy, :show]
  before_filter :admin_user, :onlu => [:new, :create, :destroy]
  
  def new
    @product = Product.new
    @title = "Add product"
  end

  def create
    @product = Product.new(params[:product])
    @product.amount = 0
    if @product.save
      flash[:success] = "Product added successfuly"
      redirect_to products_path
    else
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def index
   @title = "All products"
   @products = Product.all
  end

  def destroy
    Product.find(params[:id]).destroy
    flash[:success] = "Product destroyed"
    redirect_to products_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end 
end
