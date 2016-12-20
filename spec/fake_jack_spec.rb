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
      "Dealer: 2 11\nPlayer: \nDealer: 4\nPlayer: \nDealer: 7\nDealer  Wins!\n"
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
      "Dealer: 5 9\nPlayer: \nDealer: 6\nPlayer: \nDealer: 2 9\nPlayer  Wins!\n"
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
      "Dealer: 3 12\nPlayer: \nDealer: 4\nPlayer: \nDealer: 6\nDealer  Wins!\n"
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
      "Dealer: 6 3\nPlayer: \nDealer: 11\nPlayer: \nDealer: 6 4\nPlayer  Wins!\n"
    )
  end

  it 'scenario 5' do
    deck = build_deck(12, 10, 8, 13, 14, 6, 8, 11)
    input_stream.puts('stand')
    input_stream.rewind

    game = described_class.new(input_stream: input_stream, output_stream: output_stream, deck: deck)
    game.play

    expect(output_stream.string).to eq(
      "Dealer: 12 10\nDealer: 8 13\nDealer: 14 6\nDealer: 8 11\nPlayer: \nDealer  Wins!\n"
    )
  end

  def build_deck(*cards)
    deck = double(:deck)
    allow(deck).to receive(:next_card).and_return(
      *(cards.map { |value| FakeJack::Card.new(value: value  ) })
    )
    deck
  end
end
