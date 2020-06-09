# frozen_string_literal: true

Rails.application.config
     .session_store :redis_store,
                    servers: [
                      {
                        host: 'localhost',
                        port: 6379,
                        db: 1,
                        namespace: 'validator_session'
                      }
                    ],
                    expire_after: 90.minutes,
                    key: '_validator_session'
