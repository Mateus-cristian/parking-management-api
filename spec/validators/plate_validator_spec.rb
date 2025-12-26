# frozen_string_literal: true

require 'spec_helper'

describe Validators::PlateValidator do
  describe '.validate!' do
    it 'accepts a valid plate' do
      expect(described_class.validate!('ABC-1234')).to eq('ABC-1234')
    end

    it 'normalizes to uppercase and removes spaces' do
      expect(described_class.validate!(' abc-1234 ')).to eq('ABC-1234')
    end

    it 'rejects an invalid plate' do
      expect { described_class.validate!('123-ABCD') }.to raise_error(Errors::InvalidPlateError)
    end
  end
end
