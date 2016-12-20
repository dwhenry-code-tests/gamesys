require 'spec_helper'

RSpec.describe FakeJack do
  let(:input_stream) { StringIO.new }
  let(:output_stream) { StringIO.new }

  it 'scenario 1 - dealer wins' do
    deck = double(:deck)
    allow(deck).to receive(:next_card).and_return(
      FakeJack::Card.new(suit: '', type: '2', value: 2),
      FakeJack::Card.new(suit: '', type: 'A', value: 11),
      FakeJack::Card.new(suit: '', type: '4', value: 4),
      FakeJack::Card.new(suit: '', type: '7', value: 7),
    )

    game = described_class.new(input_stream: input_stream, output_stream: output_stream, deck: deck)

    input_stream.puts('hit')
    input_stream.puts('hit')
    input_stream.rewind
    game.play

    expect(output_stream.string).to eq(
      <<~GAME
        Dealer: 2 11
        Player: hit
        Dealer: 4
        Player: hit
        Dealer: 7
        Dealer  Wins!
      GAME
    )
  end
end
