class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String
  property :permission, String
  property :score, Integer
end
