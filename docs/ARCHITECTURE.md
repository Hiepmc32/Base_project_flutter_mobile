# Hướng Dẫn Architecture

## Architecture Style

- Clean Architecture theo hướng feature-first.
- Dùng `go_router` + Bloc/Cubit cho routing và presentation state.
- Dùng `get_it` + `injectable` cho dependency injection.
- Dùng `Either<Failure, T>` để xử lý lỗi theo hướng functional.

## Feature Layout

```text
lib/features/<feature_name>/
  presentation/
    controllers/
    pages/
    widgets/
  domain/
    entities/
    repositories/
    usecases/
  data/
    datasources/
    models/
    repositories/
```

## Chiều Dependency

- `presentation` được phụ thuộc `domain`.
- `data` được phụ thuộc domain contract.
- `domain` không phụ thuộc `presentation` và `data`.

## Core Module Dùng Chung

- `lib/core/errors/`: failures và exceptions.
- `lib/core/types/`: result typedefs.
- `lib/core/utils/network/`: network client + interceptors.
- `lib/core/config/`: flavor + runtime env config.

## Route và Dependency Injection

- Route đăng ký tập trung trong `lib/core/utils/ui/app_router.dart`.
- Mọi dependency được đăng ký tập trung qua `locator.dart` và `locator.config.dart`.
- Cubit/Controller resolve qua `getIt`, không new trực tiếp trong router/app root.
