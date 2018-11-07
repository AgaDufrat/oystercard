# frozen_string_literal: true

require 'oyster_card'

describe Oystercard do
  let(:add_top_up_money) { subject.top_up(20) }
  min_balance = Oystercard::MINIMUM_BALANCE

  it { is_expected.to respond_to :balance }

  it 'is expected to show a balance of 0' do
    expect(subject.balance).to eq 0
  end

  context 'topping up' do
    it { is_expected.to respond_to(:top_up).with(1) }

    it 'is expected to show a balance of 40' do
      add_top_up_money
      expect(subject.top_up(20)).to eq 40
    end

    it 'is expected to show error if top up exceeds 90' do
      max_balance = Oystercard::TOP_UP_MAX
      subject.top_up(max_balance)
      expect { subject.top_up(1) }.to raise_error "Balance exceeds #{max_balance}"
    end
  end

  context 'touch in' do
    it 'has not been touched in' do
      expect(subject.in_journey?).to eq false
    end

    it 'shows card has been touched in' do
      add_top_up_money
      expect { subject.touch_in("Paddington") }.to \
        change { subject.in_journey? }.from(false).to(true)
    end

    it 'does not allow touching in if balance is below the minimum level' do
      expect { subject.touch_in("Paddington") }.to raise_error 'Insufficient funds'
    end

    it 'shows the station where the card was touched in' do
      add_top_up_money
      subject.touch_in("Paddington")
      expect(subject.entry_station).to eq "Paddington"
    end
  end

  context 'touching out' do
    it 'shows card has been touched out' do
      add_top_up_money
      subject.touch_in("Paddington")
      expect { subject.touch_out }.to \
        change { subject.in_journey? }.from(true).to(false)
    end

    it 'charges the minimum balance when the card is touched out' do
      add_top_up_money
      subject.touch_in("Paddington")
      expect { subject.touch_out }.to change { subject.balance }.by(-min_balance)
    end
  end
end
