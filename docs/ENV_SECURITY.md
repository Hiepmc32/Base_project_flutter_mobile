# Environment và Security

## Environment Files

File env theo flavor:

- `env/dev.env`
- `env/uat.env`
- `env/prod.env`

File mẫu:

- `env/dev.env.example`
- `env/uat.env.example`
- `env/prod.env.example`

## Quy Tắc Security Quan Trọng

Env phía client KHÔNG phải secret storage.
Mọi thứ nằm trong app binary đều có thể bị trích xuất.

## Không Được Đưa Vào App Env

- private key
- client secret
- database credential
- server signing key

## Được Phép Đưa Vào App Env

- base URL
- public feature flag
- timeout value
- metadata không nhạy cảm

## Hardening Khuyến Nghị

1. Dùng access token có vòng đời ngắn.
2. Refresh flow phải theo policy của backend.
3. Dùng secure storage cho token.
4. Tắt `ALLOW_BAD_CERT` ở production.
5. Bật SSL pinning cho production API endpoint.

## Network Security Config

Dùng các env key sau theo flavor:

- `ENABLE_SSL_PINNING=true|false`
- `SSL_PINNED_SHA256=sha256/<base64>,sha256/<base64-2>`
- `SSL_PINNED_HOSTS=api.example.com,auth.example.com`
- `ENABLE_TOKEN_REFRESH_QUEUE=true|false`
- `ENABLE_CONNECTIVITY_GUARD=true|false`
- `AUTH_REFRESH_PATH=/auth/refresh-token`
- `AUTH_HEADER_NAME=Authorization`
- `AUTH_HEADER_PREFIX=Bearer`
- `AUTH_REFRESH_BODY_KEY=refresh_token`
- `AUTH_ACCESS_TOKEN_KEY=access_token`
- `AUTH_REFRESH_TOKEN_KEY=refresh_token`

Nếu `ENABLE_SSL_PINNING=true` nhưng `SSL_PINNED_SHA256` rỗng, base sẽ log
warning và bỏ qua pin validation.

Token auth được lưu bằng `flutter_secure_storage` và mirror vào `GetStorage`
để fallback runtime.

## SSL Pin Format

`SSL_PINNED_SHA256` hỗ trợ:

- format `sha256/<base64>`
- raw base64 hash
- SHA-256 hex 64 ký tự

Generate fingerprint bằng OpenSSL:

```bash
openssl x509 -in server.pem -pubkey -noout \
  | openssl pkey -pubin -outform der \
  | openssl dgst -sha256 -binary \
  | openssl enc -base64
```
