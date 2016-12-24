require_relative 'models'

describe Event do
  it 'date should not be in the past' do
    event = Event.new(
      name: "Birthday Party",
      host: "Nicole",
      address: "Chiang Mai",
      description: "It's a party",
      date: Date.new(2001,2,3)
    )
    expect { event.save! }.to raise_error(/Date can't be in the past/)
  end
end