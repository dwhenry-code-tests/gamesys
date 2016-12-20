class FakeJack
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
end
