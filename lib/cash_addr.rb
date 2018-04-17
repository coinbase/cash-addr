# frozen_string_literal: true

require 'cash_addr/version'
require 'cash_addr/address'
require 'cash_addr/crypto'

##
# Main module for the cash-addr gem.
module CashAddr
  ##
  # Error class for invalid address errors.
  class InvalidAddress < StandardError; end

  class Converter
    ##
    # Converts an address to \CashAddr format.
    #
    # @param address [String] A \CashAddr or Legacy address
    #
    # @return [String]
    def self.to_cash_address(address)
      CashAddr::Address.from_string(address).cash_address
    end

    ##
    # Converts an address to Legacy format.
    #
    # @param address [String] A \CashAddr or Legacy address
    #
    # @return [String]
    def self.to_legacy_address(address)
      CashAddr::Address.from_string(address).legacy_address
    end

    ##
    # Checks if an address is a valid BCH address.
    #
    # @param address [String] A \CashAddr or Legacy address
    #
    # @return [Boolean]
    def self.is_valid?(address)
      CashAddr::Address.from_string(address)
      true
    rescue CashAddr::InvalidAddress
      false
    end

    ##
    # Displays an address as \CashAddr format without the network
    # prefix (bitcoincash:)
    #
    # @param address [String] A \CashAddr or Legacy address
    #
    # @return [String]
    def self.display_address(address)
      to_cash_address(address).split(':').last.to_s
    end
  end
end
