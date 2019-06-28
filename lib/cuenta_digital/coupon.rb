# frozen_string_literal: true

module CuentaDigital
  # c = CuentaDigital::Coupon.new(id: "643232", price: 15.00, first_due_date: 1, site: 'Zorchalandia', code: "IPA", email_from: "admin@zorcha.com", email_to: 'gab.edera@gmail.com', concept: 'Probando gema de ruby', currency: :ars)
  class Coupon
    ATTRIBUTES_PRECENSE = %i[id price first_due_date code concept currency].freeze

    attr_accessor :id, # Su numero de CuentaDigital
                  :site,
                  :price, # El monto a cobrar (Debe de incluir 2 cifras adicionales que indicaran los centavos)
                  :first_due_date, # Dias desde la fecha actual hasta el vencimiento del cupon
                  :code, # Codigo para referencia del pago para integracion con sus sistemas, referencia del vendedor. (La referencia no puede superar el maximo de 50 caracteres alfanumericos)
                  :email_from, # Envio del cupon desde el email ingresado
                  :email_to, # Envio del cupon hacia el email ingresado
                  :concept, # Concepto de la venta que aparecera en el cupon
                  :currency, # La moneda base en codigo ISO en mayusculas en la cual el sistema se basara para calcular el precio correcto, dejandolo vacio la base es ARS (Pesos Argentinos), ejemplos: ARS,CLP,RBL,MXN,USD,EUR
                  :hash, # Hash opcional para control de generacion de cupones
                  :price_second_due_date, # El segundo monto a cobrar luego del primer vencimiento (Debe de incluir 2 cifras adicionales que indicaran los centavos)
                  :second_due_date, # Cantidad de dias al segundo vencimiento
                  :m0, # 1: Habilita todos los medios disponibles, 0: sin usar para deshabilitar. Default: '0'
                  :m2, # 1: Habilita Tarjetas de Credito, 0: sin usar para deshabilitar. Default: '0'
                  :m4, # 1: Para mantener habilitado medios en efectivo y Link, 0: Deshabilita Medios en Efectivo y Link. Default '1'.
                  :errors,
                  :response_code,
                  :response_body

    def initialize(params = {})
      @id = params[:id]
      @price = params[:price]
      @site = params[:site]
      @first_due_date = params[:first_due_date]
      @code = params[:code]
      @email_from = params[:email_from].nil? || params[:email_from].empty? ? nil : params[:email_from]
      @email_to = params[:email_to].nil? || params[:email_to].empty? ? nil : params[:email_to]
      @concept = params[:concept]
      @currency = params[:currency] ? params[:currency].to_sym : nil
      @hash = params[:hash]
      @price_second_due_date = params[:price_second_due_date]
      @second_due_date = params[:second_due_date]
      @m0 = params[:m0] || 0
      @m2 = params[:m2] || 0
      @m4 = params[:m4] || 1
      @errors = {}
    end

    def params
      attr_params = { id: @id,
                      precio: @price,
                      site: @site,
                      venc: @first_due_date,
                      codigo: @code,
                      concepto: @concept.to_sym,
                      moneda: CuentaDigital::CURRENCIES[@currency],
                      m0: @m0,
                      m2: @m2,
                      m4: @m4,
                      desde: @email_from,
                      hacia: @email_to,
                      precio2: @price_second_due_date,
                      vence2: @second_due_date,
                      hash: @hash }

      attr_params.delete_if { |k, v| v.nil? }
    end

    def generate(xml: true, wget: false)
      uri_params = params
      uri_params[:xml] = 1 if xml

      uri = CuentaDigital.uri_coupon_generation

      uri.query = URI.encode_www_form(uri_params.to_a)

      puts uri.to_s

      if wget
        @response_code = '200'
        @response_body = `wget -O- "#{uri.to_s}"`
      else
        @response_code = Net::HTTP.get_response(uri)
        @response_body = Net::HTTP.get_response(uri)
      end
    rescue => e
      raise e
    end

    def response
      @response = CuentaDigital::Response.new(@response_body)
    end

    def generated?
      response[:request][:action] == 'INVOICE_GENERATED'
    end

    def valid?
      validate!
      errors.empty?
    end

    private

    def validate!
      @errors = {}
      validate_attributes_presence
      validate_standar_values
      validate_format_values
    end

    def validate_attributes_presence
      missing_attributes = []
      ATTRIBUTES_PRECENSE.each do |attr|
        missing_attributes << attr if send(attr).nil?
      end

      missing_attributes.uniq.each do |attr|
        @errors[attr.to_sym] = [] unless errors.key?(attr)
        @errors[attr.to_sym] << CuentaDigital::Exception::MissingAttributes.new(attr).message
      end
    end

    def validate_standar_values
      return if CuentaDigital::CURRENCIES.keys.include?(@currency)

      @errors[:currency] = [] unless errors.key?(:currency)

      @errors[:currency] << CuentaDigital::Exception::InvalidValueAttribute.new("currency, Possible values #{CuentaDigital::CURRENCIES.keys}").message
    end

    def validate_format_values
      return if @email_to.nil? || !@email_to.match(CuentaDigital::VALID_EMAIL_REGEX).nil?

      @errors[:email_to] = [] unless errors.key?(:email_to)
      @errors[:email_to] << CuentaDigital::Exception::InvalidFormat.new(attr).message
    end
  end
end
