# vapor-auth-jwt

![Swift](https://img.shields.io/badge/swift-5.1-orange.svg)
[![Build Status](https://travis-ci.com/asensei/vapor-auth-jwt.svg?token=eSrCssnzja3G3GciyhUB&branch=master)](https://travis-ci.com/asensei/vapor-auth-jwt)

Provides custom model authentication and authorization through JWT tokens.

### Environment Variables

| Name    | Required | Default | Value (e.g.) | Description |
| ------------- |:-------------:|:-------------:|:-------------:|:-------------|
| `JWTAUTH_JWKS_URL` | ✔ | `-` | `https://YOUR_DOMAIN/.well-known/jwks.json` | JWKS URL. |
| `JWTAUTH_JWKS_CACHE_MIN_TTL` | `-` | `60` | `60` | Minimum cache time-to-live in seconds. |
