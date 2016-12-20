require 'spec_helper'

RSpec.describe FakeJack do
  let(:input_stream) { StringIO.new }
  let(:output_stream) { StringIO.new }

  it 'scenario 1' do
    deck = double
    game = described_class.new(input_stream: input_stream, output_stream: output_stream, deck: deck)

    input_stream.puts('hit')
    input_stream.puts('hit')

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
