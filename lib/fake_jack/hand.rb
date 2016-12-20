class FakeJack
  class Hand
    HIGHEST_VALID_SCORE = 21
    INITIAL_CARDS_UPPER_LIMIT = 20
    AUTO_HIT_LIMIT = 17

    def self.build_valid_hand(deck:, output_stream:)
      cards = [deck.next_card, deck.next_card]
      output_stream.puts("Dealer: #{cards[0]} #{cards[1]}")
      hand = new(deck: deck, output_stream: output_stream, cards: cards)

      if hand.valid_starting_hand?
        hand
      else
        build_valid_hand(deck: deck, output_stream: output_stream)
      end
    end

    def initialize(deck:, output_stream:, cards:)
      @deck = deck
      @output_stream = output_stream
      @cards = cards
    end

    def hit
      @cards << @deck.next_card
      @output_stream.puts("Dealer: #{@cards[-1]}")
    end

    def auto_hit
      @cards << @deck.next_card while score < AUTO_HIT_LIMIT
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
      Hand.new(deck: @deck, output_stream: @output_stream, cards: @cards.dup)
    end

    def beats?(dealer_hand)
      !busted? && (dealer_hand.busted? || dealer_hand.score < score)
    end

    def score
      values.inject(:+)
    end

    def values
      @cards.map(&:value)
    end
  end
end
