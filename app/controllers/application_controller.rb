class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :set_paper_trail_whodunnit

  class UnauthorizedUsageError < StandardError; end
  rescue_from UnauthorizedUsageError, with: :user_not_authorized
  def user_not_authorized(*)
    if request.xhr? || request.format == :json
      render json: { errors: { message: 'Access denied.' } }, status: :forbidden
    else
      flash[:notice] = t('application.user_not_authorized_error')
      redirect_to authenticated_root_url
    end
  end
end
