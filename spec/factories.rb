FactoryGirl.define do
  factory :recipe do
    name 'Chocolate Chip Cookies'
    description 'Everyone loves chocolate chip cookies'
    preparation 'Mix chocolate chips with some other stuff'
    user_id 1
    # user
  end

  factory :ingredient do
    name 'Chocolate Chips'
    user_id 2
  end

  factory :user do
    username 'pusheen'
    email 'kitty@meow.com'
    password 'kittycat'
    password_confirmation 'kittycat'
  end

  factory :cookbook do
    name 'Cookies'
    description 'Cookies are yummy.'
    user_id 1
  end
end
