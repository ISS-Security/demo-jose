require 'jose'

# 0. SETUP: App generates ands saves key-pair (Octet Key-Pair: OKP)
new_app_secret = JOSE::JWK.generate_key([:okp, :Ed25519])
new_app_public = new_app_secret.to_public

app_secret_key = Base64.strict_encode64(new_app_secret.to_okp[1]) # saved by App
app_public_key = Base64.strict_encode64(new_app_public.to_okp[1]) # saved by API

# 1. App uses secret key to sign message for API
app_secret_key = JOSE::JWK.from_okp(
  [:Ed25519, Base64.strict_decode64(app_secret_key)])
message = 'messages is here'
msg_digest = app_secret_key.sign(message).compact

# 2. API receives message and verifies sender using App's public key
app_public_key = JOSE::JWK.from_okp(
  [:Ed25519, Base64.strict_decode64(app_public_key)])
verified, jwt, jws = app_public_key.verify(msg_digest)
