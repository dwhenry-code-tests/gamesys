class FakeJack
  DEALER_MUST_HIT = 17
  INITIAL_CARDS_UPPER_LIMIT = 20

  def initialize(input_stream: STDIN, output_stream: STDOUT, deck: nil)
    @input_stream = input_stream
    @output_stream = output_stream
    @deck = deck
    @running = true

    @player_hand = Hand.new(initial_cards)
    @dealer_hand = Hand.new(initial_cards)
  end

  def play
    while running? do
      @output_stream.puts("Player: ")
      command = @input_stream.readline.chomp
      perform(command)
    end
    finalize
  end

  private

  def perform(command)
    perform_hit if command == 'hit'
    perform_stand if command == 'stand'
  end

  def perform_hit
    card = @deck.next_card
    @player_hand.deal_card(card)
    @output_stream.puts("Dealer: #{card}")
    @running = !@player_hand.busted?
  end

  def perform_stand
    dealer_hand = []
    while @dealer_hand.score < DEALER_MUST_HIT
      card = @deck.next_card
      dealer_hand << card.to_s
      @dealer_hand.deal_card(card)
    end
    @output_stream.puts("Dealer: #{dealer_hand.join(' ')}") if dealer_hand.any?
    @running = false
  end

  def finalize
    if @player_hand.busted? || (!@dealer_hand.busted? && @dealer_hand.score >= @player_hand.score)
      @output_stream.puts("Dealer  Wins!")
    else
      @output_stream.puts("Player  Wins!")
    end
  end

  def running?
    @running
  end

  def initial_cards
    @initial_hand ||= begin
      while true do
        card1 = @deck.next_card
        card2 = @deck.next_card
        @output_stream.puts("Dealer: #{card1} #{card2}")
        break if (card1.value + card2.value) < INITIAL_CARDS_UPPER_LIMIT
      end
      [card1, card2]
    end
  end

  class Hand
    HIGHEST_VALID_SCORE = 21

    def initialize(hand)
      @hand = hand.dup
    end

    def deal_card(card)
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
