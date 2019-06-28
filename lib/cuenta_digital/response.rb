# frozen_string_literal: true

module CuentaDigital
  class Response
    attr_accessor :request,
                  :action,
                  :merchant_id, # Su numero de CuentaDigital
                  :ipaddress, # IP del cliente
                  :payment_code_1, # Numero de codigo de barras
                  :payment_code_2, # Codigo de pago para la red LinkPagos.
                  :payment_code_3, # Campo reservado para futuros codigos de pago
                  :payment_code_4, # Campo reservado para futuros codigos de pago
                  :payment_code_5, # Campo reservado para futuros codigos de pago
                  :payment_code_6, # Campo reservado para futuros codigos de pago
                  :payment_code_7, # Campo reservado para futuros codigos de pago
                  :payment_code_8, # Campo reservado para futuros codigos de pago
                  :payment_code_9, # Campo reservado para futuros codigos de pago
                  :payment_code_10, # Campo reservado para futuros codigos de pago
                  :barcode_image, # URL de la imagen del codigo de barras
                  :barcode_base_64, # La imagen del codigo de barras codificada en base24
                  :invoice_url, # URL donde se encuentra el cupon de pago
                  :site, # Su Website
                  :merchant_reference, # Su referencia de pago
                  :concept, # Concepto de compra
                  :curr, # Moneda
                  :amount, # Monto a pagar (ultimas 2 cifras son decimales, ejemplo: $100.50 son 10050, 100.00 son 10000
                  :second_amount, # Monto luego del primer vencimiento
                  :date, # Fecha de generacion
                  :due_date, # Fecha de vencimiento
                  :second_due_date, # Segunda fecha de vencimiento
                  :email_to, # Enviado hacia un email.
                  :country, # Pais (codigos iso)
                  :lang # Idioma (codigos iso)

    def initialize(params)
      parser = Nori.new(convert_tags_to: proc { |tag| tag.snakecase.to_sym })
      @request = parser.parse(params)[:request]
      @action = @request[:action]
      @merchant_id = @request[:invoice][:merchantid]
      @ipaddress = @request[:invoice][:ipaddress]
      @payment_code_1 = @request[:invoice][:paymentcode1]
      @payment_code_2 = @request[:invoice][:paymentcode2]
      @payment_code_3 = @request[:invoice][:paymentcode3]
      @payment_code_4 = @request[:invoice][:paymentcode4]
      @payment_code_5 = @request[:invoice][:paymentcode5]
      @payment_code_6 = @request[:invoice][:paymentcode6]
      @payment_code_7 = @request[:invoice][:paymentcode7]
      @payment_code_8 = @request[:invoice][:paymentcode8]
      @payment_code_9 = @request[:invoice][:paymentcode9]
      @payment_code_10 = @request[:invoice][:paymentcode10]
      @barcode_image = @request[:invoice][:barcodeimage]
      @barcode_base_64 = @request[:invoice][:barcodebase64]
      @invoice_url = @request[:invoice][:invoiceurl]
      @site = @request[:invoice][:site]
      @merchant_reference = @request[:invoice][:merchantreference]
      @concept = @request[:invoice][:concept]
      @curr = @request[:invoice][:curr]
      @amount = @request[:invoice][:amount]
      @secondamount = @request[:invoice][:secondamount]
      @date = @request[:invoice][:date]
      @due_date = Time.parse(@request[:invoice][:duedate]) rescue nil
      @second_due_date = Time.parse(@request[:invoice][:secondduedate]) rescue nil
      @email_to = @request[:invoice][:emailto]
      @country = @request[:invoice][:country]
      @lang = @request[:invoice][:lang]
    end
  end
end
