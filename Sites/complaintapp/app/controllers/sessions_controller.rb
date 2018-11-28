class SessionsController < ApplicationController
  def new
  end

  def create
    name = params[:session][:user]
    pass = params[:session][:password]
    query = "(select * from camoen.users)"
    query = ApplicationRecord.execQuery(query)
    realName = query[0]["username"]
    realPass = query[0]["password"]
    if (name == realName && pass == realPass)
       @results = 'PASSED'
      session[:user] = realName
      session[:password] = realPass
      redirect_to '/queries/dashboard'
    else 
      @results = 'FAILED'
      render 'new'
    end
  end
  def destroy
    session.delete(:user)
    session.delete(:password)
  end
end