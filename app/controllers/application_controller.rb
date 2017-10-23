class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :set_csrf_cookie_for_ng

  def render *args
    global_js_variables
    super
  end

  protected

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def global_js_variables
    gon.push(
      url_find_user_by_name: find_user_by_name_path,
      url_composition_info:  info_constructor_objects_path,
    )
  end

  def ajax_error(errors)
    render json: (errors.is_a?(String) ? {common: errors} : errors), status: :unprocessable_entity
  end

  def ajax_ok(data = {})
    render json: data
  end
end
