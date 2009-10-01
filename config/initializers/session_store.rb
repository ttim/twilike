# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twilike_session',
  :secret      => 'e06007081b934c5d438234ed67297b85a8c1ccf71a2163acd64a26416301946117f7b5d1c586519ca576fcafd749af83aed9c059dca1b7e7cbf8a3e5b0d9f8eb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
