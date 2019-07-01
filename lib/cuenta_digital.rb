# frozen_string_literal: true

require 'cuenta_digital/version'
require 'cuenta_digital/coupon'
require 'cuenta_digital/response'
require 'cuenta_digital/exception'

require 'digest'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'nori'

module CuentaDigital
  class Error < StandardError; end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  CURRENCIES = { ars: 'ARS',
                 clp: 'CLP',
                 rbl: 'RBL',
                 mxn: 'MXN',
                 usd: 'USD',
                 eur: 'EUR' }.freeze

  URL = 'https://www.cuentadigital.com'
  CUOPON_GENERATION_URL = [URL, 'api.php'].join('/').freeze
  URL_EXP_DESARROLLO = [URL, 'exportacionsandbox.php'].join('/').freeze
  URL_EXP_PRODUCCION = [URL, 'exportacion.php'].join('/').freeze

  def self.uri_coupon_generation
    URI.parse(CUOPON_GENERATION_URL)
  end
end
