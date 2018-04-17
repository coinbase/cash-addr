# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CashAddr::Converter do
  let(:legacy_p2sh) { '3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTzC' }
  let(:legacy_p2pkh) { '155fzsEBHy9Ri2bMQ8uuuR3tv1YzcDywd4' }
  let(:cashaddr_p2sh) { 'bitcoincash:ppm2qsznhks23z7629mms6s4cwef74vcwvn0h829pq' }
  let(:cashaddr_p2pkh) { 'bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h' }
  let(:cashaddr_p2pkh_testnet) { 'bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf' }
  let(:legacy_p2pkh_testnet) { 'mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD' }
  let(:cashaddr_p2sh_testnet) { 'bchtest:pp8f7ww2g6y07ypp9r4yendrgyznysc9kqxh6acwu3' }
  let(:legacy_p2sh_testnet) { '2MzQwSSnBHWHqSAqtTVQ6v47XtaisrJa1Vc' }
  let(:mixed_case_cashadddr) { 'bitcoincash:qqkv9wr69ry2p9l53lxP635va4h86wv435995w8p2H' }

  context 'version' do
    it 'should have a version' do
      expect(CashAddr::VERSION).not_to be_empty
    end
  end

  context '.is_valid?' do
    it 'should return true for valid addresses' do
      expect(CashAddr::Converter.is_valid?(legacy_p2sh)).to eq(true)
      expect(CashAddr::Converter.is_valid?(legacy_p2pkh)).to eq(true)
      expect(CashAddr::Converter.is_valid?(legacy_p2pkh_testnet)).to eq(true)
      expect(CashAddr::Converter.is_valid?(legacy_p2sh_testnet)).to eq(true)
      expect(CashAddr::Converter.is_valid?(cashaddr_p2sh)).to eq(true)
      expect(CashAddr::Converter.is_valid?(cashaddr_p2pkh)).to eq(true)
      expect(CashAddr::Converter.is_valid?(cashaddr_p2pkh_testnet)).to eq(true)
      expect(CashAddr::Converter.is_valid?(cashaddr_p2sh_testnet)).to eq(true)
    end

    it 'should return false for invalid addresses' do
      expect(CashAddr::Converter.is_valid?(mixed_case_cashadddr)).to eq(false)
      expect(CashAddr::Converter.is_valid?('bad')).to eq(false)
      expect(CashAddr::Converter.is_valid?('bitcoincash:bad')).to eq(false)
      expect(CashAddr::Converter.is_valid?('bitcoincash:zz')).to eq(false)
      expect(CashAddr::Converter.is_valid?('bitcoincash:123')).to eq(false)
    end
  end

  context '.to_legacy_address' do
    it 'should convert legacy testnet p2pkh' do
      expect(CashAddr::Converter.to_legacy_address(legacy_p2pkh_testnet)).to eq(legacy_p2pkh_testnet)
      expect(CashAddr::Converter.to_legacy_address(cashaddr_p2pkh_testnet)).to eq(legacy_p2pkh_testnet)
    end

    it 'should convert legacy testnet p2sh' do
      expect(CashAddr::Converter.to_legacy_address(legacy_p2sh_testnet)).to eq(legacy_p2sh_testnet)
      expect(CashAddr::Converter.to_legacy_address(cashaddr_p2sh_testnet)).to eq(legacy_p2sh_testnet)
    end

    it 'should convert to legacy p2sh' do
      expect(CashAddr::Converter.to_legacy_address(legacy_p2sh)).to eq(legacy_p2sh)
      expect(CashAddr::Converter.to_legacy_address(cashaddr_p2sh)).to eq(legacy_p2sh)
    end

    it 'should convert to legacy p2pkh' do
      expect(CashAddr::Converter.to_legacy_address(legacy_p2pkh)).to eq(legacy_p2pkh)
      expect(CashAddr::Converter.to_legacy_address(cashaddr_p2pkh)).to eq(legacy_p2pkh)
    end

    context 'uppercase cashaddr address' do
      it 'should convert to legacy p2sh' do
        expect(CashAddr::Converter.to_legacy_address(cashaddr_p2sh.upcase)).to eq(legacy_p2sh)
      end

      it 'should convert to legacy p2pkh' do
        expect(CashAddr::Converter.to_legacy_address(cashaddr_p2pkh.upcase)).to eq(legacy_p2pkh)
      end
    end

    context 'mixed case cashaddr address' do
      it 'should raise' do
        expect do
          CashAddr::Converter.to_legacy_address(mixed_case_cashadddr)
        end.to raise_error(CashAddr::InvalidAddress, 'Cash address contains uppercase and lowercase characters')
      end
    end
  end

  context '.to_cash_address' do
    it 'should convert cash testnet p2pkh' do
      expect(CashAddr::Converter.to_cash_address(legacy_p2pkh_testnet)).to eq(cashaddr_p2pkh_testnet)
      expect(CashAddr::Converter.to_cash_address(cashaddr_p2pkh_testnet)).to eq(cashaddr_p2pkh_testnet)
    end

    it 'should convert cash testnet p2sh' do
      expect(CashAddr::Converter.to_cash_address(legacy_p2sh_testnet)).to eq(cashaddr_p2sh_testnet)
      expect(CashAddr::Converter.to_cash_address(cashaddr_p2sh_testnet)).to eq(cashaddr_p2sh_testnet)
    end

    it 'should convert to cash p2sh' do
      expect(CashAddr::Converter.to_cash_address(legacy_p2sh)).to eq(cashaddr_p2sh)
      expect(CashAddr::Converter.to_cash_address(cashaddr_p2sh)).to eq(cashaddr_p2sh)
    end

    it 'should convert to cash p2pkh' do
      expect(CashAddr::Converter.to_cash_address(legacy_p2pkh)).to eq(cashaddr_p2pkh)
      expect(CashAddr::Converter.to_cash_address(cashaddr_p2pkh)).to eq(cashaddr_p2pkh)
    end

    context 'uppercase cashaddr address' do
      it 'should convert to cash p2sh' do
        expect(CashAddr::Converter.to_cash_address(cashaddr_p2sh.upcase)).to eq(cashaddr_p2sh)
      end

      it 'should convert to cash p2pkh' do
        expect(CashAddr::Converter.to_cash_address(cashaddr_p2pkh.upcase)).to eq(cashaddr_p2pkh)
      end
    end

    context 'mixed case cashaddr address' do
      it 'should raise' do
        expect do
          CashAddr::Converter.to_cash_address(mixed_case_cashadddr)
        end.to raise_error(CashAddr::InvalidAddress, 'Cash address contains uppercase and lowercase characters')
      end
    end
  end

  context '.display_address' do
    it 'should ignore the network prefix' do
      expect(CashAddr::Converter.display_address(legacy_p2pkh)).not_to start_with('bitcoincash:')
    end

    it 'should return the expected address' do
      expect(CashAddr::Converter.display_address(legacy_p2pkh)).to eq(cashaddr_p2pkh.split(':').last)
    end
  end
end
