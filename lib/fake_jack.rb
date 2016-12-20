class FakeJack
  def initialize(input_stream: STDIN, output_stream: STDOUT, deck: nil)
    @input_stream = input_stream
    @game = Game.new(output_stream: output_stream, deck: deck)
  end

  def play
    while @game.running?
      command = @input_stream.readline.chomp
      @game.perform(command)
    end
  end

  class Game
    DEALER_MUST_HIT = 17
    INITIAL_CARDS_UPPER_LIMIT = 20

    def initialize(output_stream:, deck:)
      @output_stream = output_stream
      @deck = deck
      while true do
        shared_cards = [@deck.next_card, @deck.next_card]
        @output_stream.puts("Dealer: #{shared_cards[0]} #{shared_cards[1]}")
        break if shared_cards.map(&:value).inject(:+) < INITIAL_CARDS_UPPER_LIMIT
      end
      @player_hand = Hand.new(shared_cards)
      @dealer_cards = Hand.new(shared_cards)
      @running = true
    end

    def perform(command)
      @output_stream.puts("Player: #{command}")
      if command == 'hit'
        card = @deck.next_card
        @player_hand.add_card(card)
        @output_stream.puts("Dealer: #{card}")
        if @player_hand.busted?
          @running = false
          @output_stream.puts("Dealer  Wins!")
        end
      elsif command == 'stand'
        @running = false
        dealer_cards = []
        while @dealer_cards.score < DEALER_MUST_HIT
          card = @deck.next_card
          dealer_cards << card
          @dealer_cards.add_card(card)
        end
        @output_stream.puts("Dealer: #{dealer_cards.map(&:to_s).join(' ')}") if dealer_cards.any?
        if @dealer_cards.busted? || @dealer_cards.score < @player_hand.score
          @output_stream.puts("Player  Wins!")
        else
          @output_stream.puts("Dealer  Wins!")
        end
      end
    end

    def running?
      @running
    end

    private

    def dealer(msg)
      @output_stream.puts("Dealer: #{msg}")
    end
  end

  class Hand
    HIGHEST_VALID_SCORE = 21

    def initialize(hand)
      @hand = hand.dup
    end

    def add_card(card)
      @hand << card
    end

    def busted?
      score > HIGHEST_VALID_SCORE
    end

    def score
      @hand.map(&:value).inject(:+)
    end
  end

  class Deck
    def initialize
      @cards = %(hearts diamonds clubs spades).each do |suit|
        %(2 3 4 5 6 7 8 9 10 A J Q K).each_with_index do |type, i|
          Card.new(suit: suit, type: type, value: i + 2)
        end
      end.shuffle
      @position = 0
    end

    def next_card
      @cards.pop
    end
  end

  class Card
    attr_accessor :type, :value

    def initialize(suit:, type:, value:)
      @type = type
      @value = value
    end

    def to_s
      value.to_s
    end
  end
end
