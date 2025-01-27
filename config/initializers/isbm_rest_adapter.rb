# frozen_string_literal: true

require 'os'

Typhoeus::Config.verbose = true
IsbmRestAdaptor.configure do |conf|
  conf.host = 'isbm.lab.oiiecosystem.net'
  conf.scheme = 'https'
  conf.base_path = '/rest'
  # conf.debugging = true
  conf.ssl_ca_cert = './vendor/curl-ca-bundle.crt' if OS.windows?
  conf.username = 'client001'
  conf.password = 'password001'
end
