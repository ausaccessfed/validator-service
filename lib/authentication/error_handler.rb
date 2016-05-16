# frozen_string_literal: true
# Extends the Authentication model
module Authentication
  # Class extending the error handler for shib-rack
  class ErrorHandler
    def handle(_env, exception)
      raise exception
    end
  end
end
