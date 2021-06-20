module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    private :authenticate_user_from_token!

    before_action :authenticate_user_from_token!
  end

  def authenticate_user_from_token!
    # if user_token = params[:user_token].blank? && request.headers["X-User-Token"]
    #   params[:user_token] = user_token
    # end

    # if user_email = params[:user_email].blank? && request.headers["X-User-Email"]
    #   params[:user_email] = user_email
    # end

    # user_email = params[:user_email].presence
    # user = user_email && User.find_by(email: user_email)

    # if user && Devise.secure_compare(user.access_token, params[:user_token]) &&
    #    user.access_token_expires_at > Time.zone.now
    #   # sign_in user, store: false
    #   @current_user = user
    # else
    #   head(403)
    # end

    if request.headers["X-GEO-APIKEY"] == ENV['X_GEO_APIKEY'].to_s
      # sign_in user, store: false
      #@current_user = user
    else
      head(403)
    end
  end

  def current_user
    @current_user
  end

  module ClassMethods
  end
end
