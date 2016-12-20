require 'spec_helper'

RSpec.describe FakeJack do
  let(:input_stream) { StringIO.new }
  let(:output_stream) { StringIO.new }

  it 'scenario 1 - dealer wins' do
    deck = build_deck(2, 11, 4, 7)
    input_stream.puts('hit')
    input_stream.puts('hit')
    input_stream.rewind

    game = described_class.new(input_stream: input_stream, output_stream: output_stream, deck: deck)
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

  it 'scenario 2' do
    deck = build_deck(5, 9, 6, 2, 9)
    input_stream.puts('hit')
    input_stream.puts('stand')
    input_stream.rewind

    game = described_class.new(input_stream: input_stream, output_stream: output_stream, deck: deck)
    game.play

    expect(output_stream.string).to eq(
      <<~GAME
        Dealer: 5 9
        Player: hit
        Dealer: 6
        Player: stand
        Dealer: 2 9
        Player  Wins!
      GAME
    )
  end

  it 'scenario 3' do
    deck = build_deck(3, 12, 4, 6)
    input_stream.puts('hit')
    input_stream.puts('stand')
    input_stream.rewind

    game = described_class.new(input_stream: input_stream, output_stream: output_stream, deck: deck)
    game.play

    expect(output_stream.string).to eq(
      <<~GAME
        Dealer: 3 12
        Player: hit
        Dealer: 4
        Player: stand
        Dealer: 6
        Dealer  Wins!
      GAME
    )
  end

  it 'scenario 4' do
    deck = build_deck(6, 3, 11, 6, 4)
    input_stream.puts('hit')
    input_stream.puts('stand')
    input_stream.rewind

    game = described_class.new(input_stream: input_stream, output_stream: output_stream, deck: deck)
    game.play

    expect(output_stream.string).to eq(
      <<~GAME
        Dealer: 6 3
        Player: hit
        Dealer: 11
        Player: stand
        Dealer: 6 4
        Player  Wins!
      GAME
    )
  end

  def build_deck(*cards)
    deck = double(:deck)
    allow(deck).to receive(:next_card).and_return(
      *(cards.map { |value| FakeJack::Card.new(suit: 'hearts', type: value, value: value  ) })
    )
    deck
  end
end
