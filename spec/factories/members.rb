# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    last_name "Doe"
    first_name "John"
    sequence(:email) { |n| "john.doe.#{n}@example.com" }
    password 'secret'
    #password_confirmation 'secret'
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("secret", 
                     "asdasdastr4325234324sdfds")
    salt "asdasdastr4325234324sdfds"
    # roles
    # remember_me_token
    # remember_me_token_expires_at
  end
end
