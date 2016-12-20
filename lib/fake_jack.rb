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
    if @player_hand.busted? || (!@dealer_hand.busted? && @dealer_hand.score >= @player_hand.score)
      @output_stream.puts("Dealer  Wins!")
    else
      @output_stream.puts("Player  Wins!")
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
      if hand.valid_starting_hand?
        hand
      else
        build(deck: deck, output_stream: output_stream)
      end
    end

    def initialize(deck:, output_stream:, hand: nil)
      @deck = deck
      @output_stream = output_stream
      if hand
        @hand = hand
      else
        @hand = [@deck.next_card, @deck.next_card]
        @output_stream.puts("Dealer: #{values.join(' ')}")
      end
    end

    def deal_card(card)
      @hand << card
    end

    def hit
      @hand << @deck.next_card
      @output_stream.puts("Dealer: #{@hand[-1]}")
    end

    def auto_hit
      @hand << @deck.next_card while score < AUTO_HIT_LIMIT
      @output_stream.puts("Dealer: #{values[2..-1].join(' ')}") if @hand.size > 2
    end

    def busted?
      score > HIGHEST_VALID_SCORE
    end

    def valid_starting_hand?
      (@hand[0].value + @hand[1].value) < INITIAL_CARDS_UPPER_LIMIT
    end

    def score
      values.inject(:+)
    end

    def values
      @hand.map(&:value)
    end

    def dup
      Hand.new(deck: @deck, output_stream: @output_stream, hand: @hand.dup)
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
