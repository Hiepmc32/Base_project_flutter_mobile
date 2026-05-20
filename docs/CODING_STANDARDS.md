# Coding Standards

## Quy Ước Đặt Tên

- Class/Enum: `PascalCase`
- Method/Variable: `camelCase`
- File/Folder: `snake_case`

## Design Principles

1. Class và method nên nhỏ, single-purpose.
2. Ưu tiên model/state immutable.
3. Tránh side effect ẩn.
4. UI logic để ở `presentation`, business logic để ở `domain`.

## Error Handling

1. Dùng `Failure` cho lỗi nghiệp vụ/runtime đã dự kiến.
2. Dùng `Exception` trong internal của data source.
3. Convert exception về `Either<Failure, T>` ở repository impl.

## Logging

1. Dùng package `logging` và logger tập trung.
2. Không dùng `print` trong production code.

## Formatting & Lint

1. Giữ line length <= 80 khi hợp lý.
2. Chạy formatter trước khi commit.
3. Giữ analyzer warning/error ở mức 0.

## Documentation

1. Dùng comment `///` cho public API.
2. Comment nên tập trung vào lý do (`why`), tránh lặp lại điều hiển nhiên.
