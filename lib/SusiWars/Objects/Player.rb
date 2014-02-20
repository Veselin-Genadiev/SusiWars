module Objects
  class Player
    attr_reader :name, :fn, :faculty

    def initialize(name, fn, faculty)
      @name = name
      @fn = fn
      @faculty = faculty
    end
  end
end