class SessionsController < ApplicationController
  include SessionsHelper

  def new
    @user = User.new
  end

  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user && current_order.id
      session[:user_id] = @user.id
      current_order.save
      flash[:notice] = "Logged in!"
      redirect_to_current_restaurant_or_root
    elsif @user
      session[:user_id] = @user.id
      flash[:notice] = "Logged in!"
      redirect_to_current_restaurant_or_root
    else
      @user = User.new
      flash.now.alert = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:order_id)
    session[:user_id] = nil
    session[:current_order] = Order.new
    redirect_to root_url, :notice => "Logged out!"
  end

end
