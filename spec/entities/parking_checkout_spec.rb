# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Entities::Parking do
  describe '#mark_as_left' do
    it 'marks as left if paid' do
      parking = described_class.new(plate: 'AAA-0000', paid: true, left: false)
      expect { parking.mark_as_left }.to change { parking.left }.from(false).to(true)
      expect(parking.left_at).not_to be_nil
    end

    it 'does not raise error if already left and paid' do
      parking = described_class.new(plate: 'AAA-0000', paid: true, left: true, left_at: Time.now)
      expect { parking.mark_as_left }.not_to raise_error
      expect(parking.left).to eq(true)
    end

    it 'raises error if not paid' do
      parking = described_class.new(plate: 'AAA-0000', paid: false)
      expect { parking.mark_as_left }.to raise_error(Errors::NotPaidError)
    end
  end
end
