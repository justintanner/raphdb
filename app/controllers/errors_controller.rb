class ErrorsController < ApplicationController
  layout "error"

  def index
    if params[:message].present?
      exception = Exception.new(params[:message])
      ExceptionNotifier.notify_exception(exception, env: request.env)
    end
  end
end
