# frozen_string_literal: true
if Rails.env.production?
  SecureHeaders::Configuration.default do |config|
    config.cookies = {
      secure: true,
      httponly: true,
      samesite: {
        lax: false
      }
    }

    config.hsts = "max-age=#{6.months.to_i}; includeSubdomains; preload"
    config.x_frame_options = 'DENY'
    config.x_content_type_options = 'nosniff'
    config.x_xss_protection = '1; mode=block'
    config.x_download_options = 'noopen'
    config.x_permitted_cross_domain_policies = 'none'
    config.referrer_policy = 'origin-when-cross-origin'
    config.csp = {
      preserve_schemes: false,
      block_all_mixed_content: true,
      upgrade_insecure_requests: true,

      default_src: ["'self'"],
      base_uri: ["'self'"],
      child_src: ["'self'"],
      connect_src: [],
      font_src: ["'self'", 'data:'],
      form_action: ["'self'"],
      frame_ancestors: ["'none'"],
      img_src: ["'self'", 'data:'],
      media_src: [],
      object_src: ["'self'"],
      plugin_types: [],
      script_src: ["'self'"],
      style_src: ["'self'"],

      report_uri: ['https://aaf.report-uri.io/r/default/csp/enforce']
    }

    config.hpkp = {
      report_only: false,
      max_age: 60.days.to_i,
      include_subdomains: true,
      report_uri: 'https://aaf.report-uri.io/r/default/hpkp/enforce',
      pins: [
        # https://report-uri.io/home/pkp_hash/

        # QuoVadis EV SSL ICA G1
        { sha256: '2ZnCTNQBrKShr4c1olKfwNG53KiL6qoNcQi65YGRBn8=' },
        # QuoVadis Root CA 2
        { sha256: 'j9ESw8g3DxR9XM06fYZeuN1UB4O6xp/GAIjjdD/zM3g=' }
      ]
    }
  end
end
