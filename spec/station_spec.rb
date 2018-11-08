require 'station'

describe Station do
  let(:station) {Station.new("Paddington", 1)}

  context '#initialize' do
    it 'has a name' do
      expect(station.name).to eq "Paddington"
    end
    it 'has a zone' do
      expect(station.zone).to eq 1
    end
  end

end
