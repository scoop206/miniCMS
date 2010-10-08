# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_du_session',
  :secret      => 'dd9b0f026fc350125345904c98dd37756920a54b6c4473eeb13d41956f98a50e5a1d18c0446853f5420d9d57e7661f42fd9951ffd945f9c5ca2599e9b42f007e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
