require 'fake_jack/card'
require 'fake_jack/deck'
require 'fake_jack/hand'

class FakeJack
  def initialize(input_stream: STDIN, output_stream: STDOUT, deck: FakeJack::Deck.new)
    @input_stream = input_stream
    @output_stream = output_stream
    @deck = deck

  end

  def play
    @player_hand = Hand.build_valid_hand(deck: @deck, output_stream: @output_stream)
    @dealer_hand = @player_hand.dup
    @running = true

    process_next_command while running?

    report_winner
  end

  private

  def process_next_command
    @output_stream.print("Player: ")
    command = @input_stream.readline.chomp

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
end
