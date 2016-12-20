class FakeJack
  class Hand
    HIGHEST_VALID_SCORE = 21
    INITIAL_CARDS_UPPER_LIMIT = 20
    AUTO_HIT_LIMIT = 17

    def self.build(deck:, output_stream:)
      hand = new(deck: deck, output_stream: output_stream)
      hand.build
      if hand.valid_starting_hand?
        hand
      else
        build(deck: deck, output_stream: output_stream)
      end
    end

    def initialize(deck:, output_stream:)
      @deck = deck
      @output_stream = output_stream
    end

    def build
      @hand = [@deck.next_card, @deck.next_card]
      @output_stream.puts("Dealer: #{values.join(' ')}")
    end

    def set(hand)
      @hand = hand
    end

    def hit
      @hand << @deck.next_card
      @output_stream.puts("Dealer: #{@hand[-1]}")
    end

    def auto_hit
      @hand << @deck.next_card while score < AUTO_HIT_LIMIT
      new_cards = values[2..-1]
      @output_stream.puts("Dealer: #{new_cards.join(' ')}") if new_cards.any?
    end

    def busted?
      score > HIGHEST_VALID_SCORE
    end

    def valid_starting_hand?
      score < INITIAL_CARDS_UPPER_LIMIT
    end

    def dup
      Hand.new(deck: @deck, output_stream: @output_stream).tap do |hand|
        hand.set(@hand.dup)
      end
    end

    def beats?(hand)
      !busted? && (hand.busted? || hand.score < score)
    end

    def score
      values.inject(:+)
    end

    private

    def values
      @hand.map(&:value)
    end
  end
end
