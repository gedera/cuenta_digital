# CuentaDigital

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cuenta_digital`. To experiment with that code, run `bin/console` for an interactive prompt.

Gem for cuenta digital api service

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cuenta_digital'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cuenta_digital

## Usage

### Coupon

#### Atributes

- **id**: CuentaDigital Number.
- **price**: The amount to be charged (It must include cents with 2 digits) e.g: 17.23. greater than 5.00
- **first_due_date**: Days from the current date until the coupon expires. (Optional)
- **site**: Your site or company name.
- **code**: Payment reference for integration with your systems, reference of the seller. (The reference can not exceed a maximum of 50 alphanumeric characters).
- **email_from**: sender coupon. (Optional)
- **email_to**: receiver email. (Optional)
- **concept**: Coupon legend.
- **currency**: ISO Code e.g ejemplos: :ars, :clp, :rbl, :mxn, :usd, :eur.
- **key_hash**: secret key for coupons integration. (Optional)
- **price_second_due_date**: The amount to be charged after first due date (It must include cents with 2 digits) e.g: 17.23. (Optional)
- **second_due_date**: Days from the current date until the coupon expires. (Optional)
- **m0**: Enable all available payments service. 0: disabled 1: enabled. Default: '0'. (Optional)
- **m2**: Use service credit card. 0: disabled 1: enabled. Default: '0'. (Optional)
- **m4**: Use cash (RapiPago, PagoFacil, etc) and LinkPagos. 0: disabled 1: enabled. Default: '1'. (Optional)

#### Example

```ruby
coupon = CuentaDigital::Coupon.new(id: '643233',
                                   price: 15.00, 
                                   first_due_date: 10,
                                   site: 'Zorchalandia', 
                                   code: 'IPA', 
                                   email_from: 'admin@zorcha.com',
                                   email_to: zorcha@zorcha.com', 
                                   concept: 'Pay me now',
                                   currency: :ars)
```

#### Generate Coupon

Options:

- **xml**: Use **xml** or **http**. Default: true
- **wget**: Use **wget** or `Net::HTTP`. Default: false

This method return `CuentaDigital::Response` object

```
-> response = coupon.generate() # xml: true, wget: false
-> response = coupon.generate(xml: false) # xml: false, wget: false
-> response = coupon.generate(wget: true) # xml: true, wget: true
```

#### Optional methods

- **valid?**: If a valid cupoun.
- **generated?**: coupon generated on CuentaDigital
- **response**: `CuentaDigital::Response`
- **params**: params to use in `generate` method

### Response

- **request**:
- **action**:
- **merchant_id**: CuentaDigital Number
- **ipaddress**: Client ip
- **payment_code_1**: Bar code number
- **payment_code_2**: Code red LinkPagos
- **payment_code_3**: Field reserved
- **payment_code_4**: Field reserved
- **payment_code_5**: Field reserved
- **payment_code_6**: Field reserved
- **payment_code_7**: Field reserved
- **payment_code_8**; Field reserved
- **payment_code_9**: Field reserved
- **payment_code_10**: Field reserved
- **barcode_image**: Bar code image URL
- **barcode_base_64**: Bar code imagen in base24
- **invoice_url**: coupon URL
- **site**: Your site or company name.
- **merchant_reference**: Payment reference for integration with your systems, reference of the seller. (The reference can not exceed a maximum of 50 alphanumeric characters).(Used in code attribute in model Coupon)
- **concept**: Coupon legend.
- **curr**: Currency
- **amount**: Amount
- **second_amount**: Second Amount
- **date**: Generation date
- **due_date**: First due duate
- **second_due_date**: Second due date
- **email_to**: send to.
- **country**: Country (ISO Code)
- **lang**: Language (ISO Code)
- **error**:
- **exception**:

### Payment

#### Attributes

- **operation_kind**
- **payment_date**
- **gross_amount**
- **net_amount**
- **commission**
- **reference**
- **payment_method**
- **operation_id**
- **payment_number**
- **checksum**
- **operation_event_number**
- **bar_code**

#### Methods

- [class method] `process_webhook`:

```ruby
CuentaDigital::Payment.process_webhook(csv) # String csv separated by ','
```

return arrays of `CuentaDigital::Payment`

- [class method] `request`. Only get transactions completed


```ruby
CuentaDigital::Payment.request(control:, date: Time.now, from: nil, to: nil, opts: { wget: false, sandbox: false })
```

- **control**: this ID appears in https://www.cuentadigital.com/area.php?name=Exportacion
- **date**: Day to check
- **from**: from a specific time. Default: beginning of day
- **to**: to a specific time. Default: end of day
- **opts**: 
  - **wget**: Use **wget** or `Net::HTTP`. Default: false.
  - **sandbod**: Use sandbox tool.

return arrays of `CuentaDigital::Payment`

#### Example

```ruby
CuentaDigital::Payment.request(control: 'e9161bfccfba345237fb1311b890203f', date: Time.new(2019, 07, 01), opts: { wget: false, sandbox: true })
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gedera/cuenta_digital. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CuentaDigital project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/gedera/cuenta_digital/blob/master/CODE_OF_CONDUCT.md).
