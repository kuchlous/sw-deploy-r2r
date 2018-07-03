# Be sure to restart your server when you modify this file.

require 'action_dispatch/middleware/session/couchbase_store'

cache_options = {
    :bucket => "spp",
    :username => "spp",
    :password => "password",
    :node_list => ["#{ENV['COUCHBASE_IP']}:8091"]
  }

Rails.application.config.session_store :cookie_store, key: '_spp_session'

