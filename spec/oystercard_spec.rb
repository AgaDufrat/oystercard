# frozen_string_literal: true

require 'oyster_card'

describe Oystercard do
  let(:add_top_up_money) { subject.top_up(20) }
  let(:station) { double :station }
  min_balance = Oystercard::MINIMUM_BALANCE

  context 'initialization' do
    it 'is expected to show a balance of 0 when created' do
      expect(subject.balance).to eq 0
    end

    it 'has no journey history' do
      expect(subject.journey_history).to eq []
    end
  end

  context '#top_up' do
    it 'is expected to increase the balance by the stated amount' do
      expect { subject.top_up(20) }.to change { subject.balance }.by 20
    end

    it 'is expected to show error if top up exceeds maximum balance' do
      max_balance = Oystercard::TOP_UP_MAX
      subject.top_up(max_balance)
      expect { subject.top_up(1) }.to raise_error "Balance exceeds #{max_balance}"
    end
  end

  context 'touch in' do
    it 'has not been touched in when created' do
      expect(subject.in_journey?).to eq false
    end

    it 'shows card has been touched in' do
      add_top_up_money
      expect { subject.touch_in(:station) }.to \
        change { subject.in_journey? }.from(false).to(true)
    end

    it 'does not show an exit station after touching in' do
      add_top_up_money
      subject.touch_in(:station)
      subject.touch_out(:station)
      subject.touch_in(:station)
      expect(subject.exit_station).to eq nil
    end

    it 'does not allow touching in if balance is below the minimum level' do
      expect { subject.touch_in(:station) }.to raise_error 'Insufficient funds'
    end

    it 'shows the station where the card was touched in' do
      add_top_up_money
      subject.touch_in(:station)
      expect(subject.entry_station).to eq :station
    end
  end

  context 'touching out' do
    it 'shows card has been touched out' do
      add_top_up_money
      subject.touch_in(:station)
      expect { subject.touch_out(:station) }.to \
        change { subject.in_journey? }.from(true).to(false)
    end

    it 'charges the minimum balance when the card is touched out' do
      add_top_up_money
      subject.touch_in(:station)
      expect { subject.touch_out(:station) }.to change { subject.balance }.by(-min_balance)
    end

    it 'it forgets the entry station when the card is touched out'do
      add_top_up_money
      subject.touch_in(:station)
      subject.touch_out(:station)
      expect(subject.entry_station).to eq nil
    end

    it 'stores the exit station when touched out' do
      add_top_up_money
      subject.touch_in(:station)
      subject.touch_out(:station)
      expect(subject.exit_station).to eq :station
    end
  end
end
