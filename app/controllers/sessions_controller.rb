class SessionsController < ApplicationController
  def new
  end

  def create
  	member = login(params[:email], params[:password], params[:remember_me])
  	if member
  	  redirect_back_or_to root_url, notice:"Logged in!"
  	else
  	  flash.now.alert = "Email or password was invalid"
  	  render :new
  	end
  end

  def destroy
  	logout
  	redirect_to root_url, notice:"Logged out!"
  end
end
