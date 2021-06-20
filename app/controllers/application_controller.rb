class ApplicationController < ActionController::Base
  include Pagy::Backend
  layout 'dashboard'
  before_action :authenticate_user!, :inspect_user_access


  def inspect_user_access
    if Rails.env.production?
      if current_user && !current_user.tags.where(name: 'ACCESS', active: true).first
        sign_out current_user
        render 'errors/forbidden', :status => :forbidden , :layout => false
      end
    end
  end
end
