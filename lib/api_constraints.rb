# frozen_string_literal: true
# Class that handles routing api versions based on 'accept' header
class APIConstraints
  def initialize(version:, default: false)
    @version = version
    @default = default
  end

  def matches?(req)
    @default || req.headers['Accept'].include?(version_string)
  end

  private

  def version_string
    "application/vnd.aaf.validator-service.v#{@version}+json"
  end
end
