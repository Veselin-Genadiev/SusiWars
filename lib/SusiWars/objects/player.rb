module Objects
  class Player
    attr_reader :name, :fn, :faculty, :is_in_battle, :score

    def initialize(name, fn, score = 0, faculty = 'FMI')
      @name = name
      @fn = fn
      @faculty = faculty
      @is_in_battle = false
      @score = score
    end

    def add_win
      @score += 2
    end

    def add_draw
      @score += 1
    end

    def add_lose
      @score -= 1
    end
  end
end