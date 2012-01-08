require 'net/http'
require 'json'

class ApiController < ApplicationController

  respond_to :json
  before_filter :authenticate

  def index
    respond_with to_client
  end

  def update
    if Product.exists?(:id => params[:id])
      @product = Product.find(params[:id])
      @product.amount += params[:amount].to_i
      @product.save
      return head(:ok)
    else
      return head(:not_found)
    end
  end

  private
    
    def to_client
      Product.all.map { |p| {"id" => p.name, "prize" => p.prize, "amount" => 0} }
    end

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "user" && password == "K3JZGDptJmWeN"
      end
    end
end
