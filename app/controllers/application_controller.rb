class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  require 'active_support'

  rescue_from CanCan::AccessDenied do |exception|
  	
    redirect_to root_url, :alert => "对不起，您没有该操作的权限！"
  end

  
end
