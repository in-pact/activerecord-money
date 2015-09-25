require "activerecord-money/version"

module ActiveRecord::Money
  extend ActiveSupport::Concern

  def default_money_currency(options)
    options[:default_currency] ||= Money.default_currency
  end

  def currency_field(name, options)
    options[:currency] || :"#{name}_currency"
  end

  def money_currency(name, options)
    attribute_name = currency_field(name, options)
    default_currency = default_money_currency(options)

    currency = respond_to?(attribute_name) ? send(attribute_name) : nil
    currency || default_currency
  end

  def blank_money?(value, options)
    options[:allow_nil] and value.blank?
  end

  def money_reader(name, options = {})
    value = send("#{name}_in_cents")
    blank_money?(value, options) ? nil : Money.new(value || 0, money_currency(name, options))
  end

  def money_writer(name, value, options = {})
    currency_attribute_name = currency_field(name, options)
    currency_name = money_currency(name, options)

    if value.is_a? Money
      send("#{name}_in_cents=", value.cents)
      send("#{currency_attribute_name}=", "#{value.currency.id}") if respond_to? "#{currency_attribute_name}="
    elsif !value.blank?
      value = value.to_money(currency_name)
      money_writer(name, value, options)
    else
      money_writer(name, 0.to_money(currency_name), options) unless blank_money?(name, options)
    end

    value
  end

  module ClassMethods
    def money(name, options = {})
      class_eval(<<-EOS, __FILE__, __LINE__)
      def #{name}
        money_reader(:#{name},#{options.inspect})
      end

      def #{name}=(value)
        money_writer(:#{name},value,#{options.inspect})
      end

      EOS
    end
  end
end

class Money

  def -@
    Money.new(-cents, currency)
  end

end
