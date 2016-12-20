class FakeJack
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
