require 'net/http'
class ProductsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :update, :show, :send_amount]
  before_filter :admin_user, :only => [:new, :create]
  
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
   get_products
   @products = Product.all
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      flash[:success] = "Product has been actualized"
      send_amount(@product.id)
    else
      @title = "Edit product"
      render 'edit'
    end
  end

  def send_amount(product_id)
    @product = Product.find(product_id)
    @product.amount = 0 if @product.amount.nil?
    
    url = "http://pai-central.heroku.com/api/#{@product.id}?amount=#{@product.amount_sent}"
    uri = (URI.parse(url) rescue nil)

    Net::HTTP.start(uri.host, uri.port) do |http|
      headers = {'Content-Type' => 'text/plain; charset=utf-8',
                 'Authorization' => 'Basic dXNlcjpLM0paR0RwdEptV2VO'}
      response = http.send_request('PUT', uri.request_uri, "", headers)
      if response.code.to_i == 200
        @product.amount += @product.amount_sent 
        @product.amount_sent = 0
      end
      @product.save
    end
    redirect_to products_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end 

    def exists?(product)
      Product.all.each do |p|
        if p.index == product.index
          return true
        end
      end
      false
    end

    def get_products
      @data = nil
      Net::HTTP.start('pai-central.heroku.com') {|http|
        req = Net::HTTP::Get.new('/api')
        req.basic_auth 'user', 'K3JZGDptJmWeN'
        response = http.request(req)
        @data = response.body
      }
      json = JSON.parse(@data)
      @fetched_products = Array.new
      json.each do |p|
        p["index"] = p.delete("id")
        @fetched_products << Product.new(p)
        Product.create!(p) unless exists? Product.new(p)
      end
      remove_destroyed_products
    end

    def remove_destroyed_products
      products = Product.all.map { |p| p.index }
      fetched_indexes = @fetched_products.map { |p| p.index }

      Product.all.each do |p|
        p.destroy unless fetched_indexes.include?(p.index)
      end
    end
end
