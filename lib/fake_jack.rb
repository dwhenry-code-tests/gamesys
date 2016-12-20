class FakeJack
  def initialize(input_stream: STDIN, output_stream: STDOUT, deck: nil)
    @input_stream = input_stream
    @output_stream = output_stream
    @deck = deck

  end

  def play
    @player_hand = Hand.build(deck: @deck, output_stream: @output_stream)
    @dealer_hand = @player_hand.dup
    @running = true

    while running? do
      @output_stream.puts("Player: ")
      command = @input_stream.readline.chomp
      perform(command)
    end
    report_winner
  end

  private

  def perform(command)
    if command == 'hit'
      @player_hand.hit
      @running = !@player_hand.busted?
    end

    if command == 'stand'
      @dealer_hand.auto_hit
      @running = false
    end
  end

  def report_winner
    if @player_hand.beats?(@dealer_hand)
      @output_stream.puts("Player  Wins!")
    else
      @output_stream.puts("Dealer  Wins!")
    end
  end

  def running?
    @running
  end

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

  class Deck
    def initialize
      @cards = %(hearts diamonds clubs spades).each do |_suit|
        %(2 3 4 5 6 7 8 9 10 A J Q K).each_with_index do |_type, i|
          Card.new(value: i + 2)
        end
      end.shuffle
    end

    def next_card
      @cards.pop
    end
  end

  class Card
    attr_accessor :type, :value

    def initialize(value:)
      @value = value
    end

    def to_s
      value.to_s
    end
  end
end
