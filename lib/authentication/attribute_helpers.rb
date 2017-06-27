# frozen_string_literal: true

module Authentication
  class AttributeHelpers
    GENERIC_HTTP_HEADERS = %w[
      HTTP_ACCEPT
      HTTP_ACCEPT_CHARSET
      HTTP_ACCEPT_ENCODING
      HTTP_ACCEPT_LANGUAGE
      HTTP_CACHE_CONTROL
      HTTP_CLIENT_IP
      HTTP_CONNECTION
      HTTP_CONTENT_LENGTH
      HTTP_CONTENT_TYPE
      HTTP_COOKIE
      HTTP_FORWARDED
      HTTP_HOST
      HTTP_IF_MODIFIED_SINCE
      HTTP_IF_NONE_MATCH
      HTTP_KEEP_ALIVE
      HTTP_PROXY_CONNECTION
      HTTP_REFERER
      HTTP_UPGRADE_INSECURE_REQUESTS
      HTTP_USER_AGENT
      HTTP_VERSION
    ].uniq.freeze

    class << self
      def federation_attributes(env)
        env.select do |header|
          header.starts_with?('HTTP_') &&
            !header.starts_with?('HTTP_X_') &&
            !GENERIC_HTTP_HEADERS.include?(header)
        end
      end
    end
  end
end
