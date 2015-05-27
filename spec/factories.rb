FactoryGirl.define do
  factory :ticket_kind do
    sequence(:title) { |n| "ticket_kind_#{n}"}
    template "Template text here! Your code here: %CODE%."
    subject "Your ticket!"
  end

  factory :batch do
    emails "foo@bar.com\nbaz@qux.org"
    ticket_kind
    created_at Time.now
  end

  factory :event do
    sequence(:title) { |n| "event_#{n}"}
  end

  factory :ticket do
    batch
    event
    sequence(:email) { |n| "ticket_#{n}@provider.com"}
    report nil
    processed_at Time.now
  end

  factory :user do
    sequence(:login) { |n| "login_#{n}"}
    email { |r| "#{r.login.downcase}@provider.com" }
    password "mypassword"
    password_confirmation "mypassword"
    password_salt { |r| Authlogic::Random.hex_token }
    crypted_password { |r| Authlogic::CryptoProviders::Sha512.encrypt(r.login + r.password_salt) }
    persistence_token { |r| Authlogic::Random.hex_token }
    single_access_token { |r| Authlogic::Random.friendly_token }
    perishable_token { |r| Authlogic::Random.friendly_token }
  end
end
