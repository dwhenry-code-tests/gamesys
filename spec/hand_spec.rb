require 'spec_helper'

RSpec.describe FakeJack::Hand do
  let(:output_stream) { StringIO.new }
  subject { described_class.new(deck: deck, output_stream: output_stream, cards: cards) }

  describe '.build_valid_hand' do
    let(:deck) { double(:deck) }
    let(:card_value_8) { double(:card, value: 8, to_s: '8') }
    let(:card_value_11) { double(:card, value: 11, to_s: '11') }

    it 'will create a hand with the first two cards in the deck' do
      allow(deck).to receive(:next_card).and_return(card_value_8, card_value_8)

      hand = described_class.build_valid_hand(deck: deck, output_stream: output_stream)
      expect(hand.values).to eq([8, 8])
    end

    it 'will create hands until it finds one with a score before the max initial starting score' do
      allow(deck).to receive(:next_card).and_return(*(11.times.map { card_value_11 }), card_value_8)

      hand = described_class.build_valid_hand(deck: deck, output_stream: output_stream)
      expect(hand.values).to eq([11, 8])
    end

    it 'logs to successful and unsuccessful hand creation' do
      allow(deck).to receive(:next_card).and_return(*(3.times.map { card_value_11 }), card_value_8)

      described_class.build_valid_hand(deck: deck, output_stream: output_stream)
      expect(output_stream.string).to eq("Dealer: 11 11\nDealer: 11 8\n")
    end
  end

  describe '#hit' do
    let(:card_value_5) { double(:card, value: 5, to_s: '5') }
    let(:deck) { double(:deck, next_card: card_value_5) }
    let(:cards) { [] }

    it 'pops the next card off the deck' do
      expect(deck).to receive(:next_card)
      subject.hit
    end

    it 'adds the card from the deck to the hand' do
      subject.hit
      expect(subject.values).to eq([5])
    end

    it 'outputs the value of the next card' do
      subject.hit
      expect(output_stream.string).to eq("Dealer: 5\n")
    end
  end

  describe '#auto_hit' do
    let(:deck) { double(:deck) }
    let(:card_value_0) { double(:card, value: 0, to_s: '0') }
    let(:card_value_1) { double(:card, value: 1, to_s: '1') }
    let(:cards) { [card_value_0, card_value_0] }
    before {
      allow(deck).to receive(:next_card).and_return(card_value_1)
    }

    it 'will retrieve cards from the deck while score < AUTOHIT_LIMIT' do
      expect(deck).to receive(:next_card).exactly(17).times
      subject.auto_hit
    end

    it 'outpus all cards that have been added to the hand' do
      subject.auto_hit
      expect(output_stream.string).to eq("Dealer: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n")
    end
  end

  describe '#dup' do
    let(:deck) { double(:deck, next_card: card_value_2) }
    let(:card_value_0) { double(:card, value: 0, to_s: '0') }
    let(:card_value_1) { double(:card, value: 1, to_s: '1') }
    let(:card_value_2) { double(:card, value: 2, to_s: '2') }
    let(:cards) { [card_value_0, card_value_1] }
    let!(:hand) { subject.dup }

    it 'creates a duplicate hand with the same cards' do
      expect(hand.values).to eq(subject.values)
    end

    it 'does not share data objects - i.e. updating the original wont update the duplicate' do
      subject.hit
      expect(hand.values).not_to eq(subject.values)
    end

    it 'does not share data objects - i.e. updating the duplicate wont update the original' do
      hand.hit
      expect(hand.values).not_to eq(subject.values)
    end
  end

  describe '#beats?' do
    let(:deck) { double(:deck) }
    let(:card_value_2) { double(:card, value: 2, to_s: '3') }
    let(:card_value_4) { double(:card, value: 4, to_s: '4') }
    let(:card_value_10) { double(:card, value: 10, to_s: '10') }
    let(:cards) { [card_value_10] }
    let(:dealer) { double(:dealer, busted?: false, score: 12) }

    it 'player has busted' do
      cards << card_value_10 << card_value_10
      expect(subject.beats?(dealer)).to be_falsey
    end

    it 'dealer has busted' do
      expect(dealer).to receive(:busted?).and_return(true)
      expect(subject.beats?(dealer)).to be_truthy
    end

    it 'player has a lower hand value than the dealer' do
      expect(subject.beats?(dealer)).to be_falsey
    end

    it 'player has a higher hand value than the dealer' do
      cards << card_value_4
      expect(subject.beats?(dealer)).to be_truthy
    end

    it 'player has a the same hand value as the dealer'  do
      cards << card_value_2
      expect(subject.beats?(dealer)).to be_falsey
    end
  end
end
