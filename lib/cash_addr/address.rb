# frozen_string_literal: true

require 'base58'
require 'digest'

module CashAddr
  class Address
    attr_accessor :version, :payload, :prefix, :digest

    VERSION_MAP = {
      'legacy' => [
        ['P2SH', 5],
        ['P2PKH', 0],
        ['P2SHTestnet', 196],
        ['P2PKHTestnet', 111]
      ],
      'cash' => [
        ['P2SH', 8],
        ['P2PKH', 0],
        ['P2SHTestnet', 8],
        ['P2PKHTestnet', 0]
      ]
    }.freeze
    DEFAULT_PREFIX = 'bitcoincash'

    def initialize(version, payload, prefix = nil, digest = nil)
      @version = version
      @payload = payload
      @digest = digest

      @prefix = prefix ? prefix : DEFAULT_PREFIX

      @version = 'P2SHTestnet' if prefix == 'bchtest' && version == 'P2SH'
      @version = 'P2PKHTestnet' if prefix == 'bchtest' && version == 'P2PKH'
      @prefix = 'bchtest' if %w[P2SHTestnet P2PKHTestnet].include?(@version)
    end

    def legacy_address
      version_int = self.class.address_type('legacy', version)[1]
      input = self.class.code_list_to_string([version_int] + payload + Array(digest))
      input += Digest::SHA256.digest(Digest::SHA256.digest(input))[0..3] unless digest
      Base58.binary_to_base58(input, :bitcoin)
    end

    def cash_address
      version_int = self.class.address_type('cash', version)[1]
      p = [version_int] + payload
      p = CashAddr::Crypto.convertbits(p, 8, 5)
      checksum = CashAddr::Crypto.calculate_checksum(prefix, p)
      prefix + ':' + CashAddr::Crypto.b32encode(p + checksum)
    end

    def self.code_list_to_string(code_list)
      code_list.map { |i| Array(i).pack('C*') }.flatten.join
    end

    def self.address_type(address_type, version)
      VERSION_MAP[address_type].each do |mapping|
        return mapping if mapping.include?(version)
      end

      raise(CashAddr::InvalidAddress.new, 'Could not determine address version')
    end

    def self.from_string(address_string)
      raise(CashAddr::InvalidAddress, 'Expected string as input') unless address_string.is_a?(String)
      return legacy_string(address_string) unless address_string.include?(':')
      cash_string(address_string)
    end

    def self.legacy_string(address_string)
      decoded = nil
      begin
        decoded = Base58.base58_to_binary(address_string, :bitcoin).bytes
      rescue StandardError
        raise(CashAddr::InvalidAddress.new, 'Could not decode legacy address')
      end
      ver = address_type('legacy', decoded[0].to_i)[0]
      payload = decoded[1..-5]
      digest = decoded[-4..-1]

      new(ver, payload, nil, digest)
    end

    def self.cash_string(address_string)
      if address_string.upcase != address_string && address_string.downcase != address_string
        raise(CashAddr::InvalidAddress.new, 'Cash address contains uppercase and lowercase characters')
      end

      address_string = address_string.downcase
      if !address_string.include?(':')
        address_string = DEFAULT_PREFIX + ':' + address_string
      end

      pre, base32string = address_string.split(':')
      decoded = CashAddr::Crypto.b32decode(base32string)

      if !CashAddr::Crypto.verify_checksum(pre, decoded)
        raise(CashAddr::InvalidAddress.new, 'Bad cash address checksum')
      end

      converted = CashAddr::Crypto.convertbits(decoded, 5, 8)
      ver = CashAddr::Address.address_type('cash', converted[0].to_i)[0]
      p = converted[1..-7]

      new(ver, p, pre, nil)
    end
  end
end
