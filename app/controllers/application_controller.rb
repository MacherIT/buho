class ApplicationController < ActionController::Base
  I18n.locale = :es
  respond_to :html, :json
end
