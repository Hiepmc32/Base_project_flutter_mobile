# CI/CD Baseline

## Pipeline Stages

1. `analyze`
2. `test`
3. `deploy`

## Analyze Stage (Bắt Buộc)

- cài dependency
- chạy formatter check
- chạy analyzer

## Test Stage (Bắt Buộc)

- chạy unit/widget test
- thu thập và publish test report nếu có

## Deploy Stage (Tag-based)

- parse flavor/version/build từ tag
- tải env file từ CI secure storage
- build Android/iOS artifact
- upload artifact và publish distribution

## File Cần Có Để Chạy Full Pipeline

- `.gitlab-ci.yml`
- `Makefile` (hoặc script entrypoint tương đương)
- `melos.yaml` nếu cần orchestration kiểu monorepo
- setup Fastlane nếu release automation dùng Fastlane

## Gate Policy

Không được deploy nếu:

- analyzer fail
- test fail
- thiếu env file
- sai format version/tag
