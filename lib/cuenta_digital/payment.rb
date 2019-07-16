# frozen_string_literal: true

module CuentaDigital
  # Codigo de operacion: 1: credito (ingreso de fondos,recaudaciones), 2: debito (retiros, pagos a terceros, pago de servicios, contracargos,etc)
  # El Checksum de la operacion (firma) corresponde a una encriptacion SHA256 concatenando la clase de operacion, la fecha de la operacion, hora de la operacion, Monto, Codigo de Barras, Referencia, Codigo unico de operacion y la clave de seguridad ash('sha256',ClaseDDMMYYYHHMMSSMontoBarraReferenciaUnicoClave), su finalidad es la validacion de la operacion.

  class Payment
    attr_accessor :operation_kind,
                  :payment_date,
                  :gross_amount,
                  :net_amount,
                  :commission,
                  :reference,
                  :payment_method,
                  :operation_id,
                  :payment_number,
                  :checksum,
                  :operation_event_number,
                  :bar_code,
                  :secret,
                  :csv_line

    def initialize(params = {})
      @operation_id = params[:operation_id]
      @operation_kind = params[:operation_kind]
      @payment_date = params[:payment_date]
      @gross_amount = params[:gross_amount]
      @net_amount = params[:net_amount]
      @commission = params[:commission]
      @reference = params[:reference]
      @payment_method = params[:payment_method]
      @payment_number = params[:payment_number]
      @checksum = params[:checksum]
      @bar_code = params[:bar_code]
      @csv_line = params[:csv_line]
      @secret = params[:secret]
    end

    def credit?
      @operation_kind == 1
    end

    def debit?
      @operation_kind == 0
    end

    def secret_valid?
      secret.nil? || Digest::SHA256.hexdigest(@secret) == @checksum
    end

    def self.uri(control:, sandbox: false, date: Time.now, from: nil, to: nil)
      uri_request = if sandbox
                      CuentaDigital.sandbox_uri_payment_export
                    else
                      CuentaDigital.uri_payment_export
                    end

      from = {
        hour: (from.nil? ? '00' : from.strftime('%H')),
        min: (from.nil? ? '00' : from.strftime('%M'))
      }

      to = {
        hour: (to.nil? ? '23' : to.strftime('%H')),
        min: (to.nil? ? '59' : to.strftime('%M'))
      }

      uri_params = {
        control: control,
        fecha: date.strftime('%Y%m%d'),
        hour1: from[:hour],
        min1: from[:min],
        hour2: to[:hour],
        min2: to[:min]
      }

      uri_request.query = URI.encode_www_form(uri_params.to_a)

      uri_request
    end

    # only get transactions completed
    # Explicacion de la estructura
    # Fecha del cobro|Horario de la operacion (HHmmss)|Monto Bruto|Monto neto recibido|Comision|Su referencia|Medio de pago usado|Codigo interno unico de operacion|Cobro numero 1 del archivo
    # Ejemplo de una linea del archivo:
    # 30122008|221500|1000.50|999.50|1.00|cliente9879|PagoFacil|23a0f1c7b636c08660abbe4f02360633-de70dbb3f907c613ddce6566667f92c6|1
    def self.collector(control:, date: Time.now, from: nil, to: nil, opts: { wget: false, sandbox: false })
      retries = 0

      uri_request = uri(control: control, sandbox: opts[:sandbox], date: date, from: from, to: to)

      begin
        results = if opts[:wget]
                    `wget -O- "#{uri_request.to_s}"`
                  else
                    partial_response = Net::HTTP.get_response(uri_request)

                    if partial_response.code == '200'
                      partial_response.body
                    else
                      raise StandardError, partial_response.body
                    end
                  end
      rescue SocketError => e
        if retries < 3
          retries += 1
          retry
        end
        raise e
      end

      results.split("\n").map do |result|
        puts result
        args = result.split('|')

        params = {
          csv_line: result,
          operation_kind: 1, # Credit
          payment_date: Time.parse(
            [
              args[0].insert(2, '-').insert(5, '-'),
              args[1].insert(2, ':').insert(5, ':')
            ].join(' ')
          ),
          gross_amount: args[2],
          net_amount: args[3],
          commission: args[4],
          reference: args[5],
          payment_method: args[6],
          operation_id: args[7],
          payment_number: args[8]
        }

        CuentaDigital::Payment.new(params)
      end
    end
  end
end
