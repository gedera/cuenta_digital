# frozen_string_literal: true

module CuentaDigital
  # Linea de operaciones:
  # CSV: Clase de operacion,Fecha de la operacion,Hora de la operacion,Monto,Codigo de Barras,Referencia,Medio de pago,Codigo unico de operacion,Checksum de operacion,Numero de operacion en evento
  # Linea final:
  # CSV: Valor fijo 3 indicando linea final,Fecha actual,Horario actual,Monto total de creditos en evento,Monto total de debitos en evento,Cantidad de operaciones,Checksum

  # El Checksum de la operacion (firma) corresponde a una encriptacion SHA256 concatenando:
  # - la clase de operacion,
  # - la fecha de la operacion,
  # - hora de la operacion,
  # - Monto,
  # - Codigo de Barras,
  # - Referencia,
  # - Codigo unico de operacion
  # - clave de seguridad
  # ash('sha256',ClaseDDMMYYYHHMMSSMontoBarraReferenciaUnicoClave),
  # su finalidad es la validacion de la operacion.
  class Webhook
    def self.process_webhook(csv, secret = nil)
      csv_splitted = csv.split("\n")
      _final_line = csv_splitted.pop

      csv_splitted.map do |result|
        args = result.split(',')

        params = {
          csv_line: result,
          secret: secret,
          operation_kind: args[0],
          payment_date: Time.parse(
            [
              args[1].insert(2, '-').insert(5, '-'),
              args[2].insert(2, ':').insert(5, ':')
            ].join(' ')
          ),
          net_amount: args[3],
          bar_code: args[4],
          reference: args[5],
          payment_method: args[6],
          operation_id: args[7],
          checksum: args[8],
          operation_event_number: args[9]
        }

        params[:secret] = if secret
                            [args[0],
                             args[1].delete('-'),
                             args[2].delete(':'),
                             args[3],
                             args[4],
                             args[5],
                             args[7],
                             secret].sum
                          end

        CuentaDigital::Payment.new(params)
      end
    end
  end
end
