class Game
  include DataMapper::Resource

  property :id, Serial

  has n, :questions
  has n, :users
end
