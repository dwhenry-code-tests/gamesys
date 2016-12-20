class FakeJack
  def initialize(input_stream: STDIN, output_stream: STDOUT, deck: nil)
    @input_stream = input_stream
    @output_stream = output_stream
    @deck = deck
  end

  def play
    @output_stream.puts('Dealer: 2 11')
    @output_stream.puts('Player: hit')
    @output_stream.puts('Dealer: 4')
    @output_stream.puts('Player: hit')
    @output_stream.puts('Dealer: 7')
    @output_stream.puts('Dealer  Wins!')
  end
end
