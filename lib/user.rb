class User
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String
  property :permission, String
  property :score, Integer
end
