class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'core'

  after_filter  :print_details

  def print_details
    Rails.logger.info " PARAMETERS: #{params.inspect}"
  end
  private :print_details
end
