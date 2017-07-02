# frozen_string_literal: true

module Authentication
  class ErrorHandler
    def handle(_env, exception)
      raise exception
    end
  end
end
