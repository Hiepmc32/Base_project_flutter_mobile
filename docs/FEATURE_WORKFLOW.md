# Feature Workflow

## Chọn Manual Hay Dùng Library

Dùng ma trận sau trước khi implement:

1. Dùng code sẵn trong base nếu feature đáp ứng được bằng core module hiện có.
2. Cài package khi:
   - chức năng đủ phức tạp,
   - package ổn định, còn maintenance,
   - giúp giảm bug surface khi tự code tay.
3. Implement manual khi:
   - tính năng đơn giản,
   - package làm tăng độ phức tạp không cần thiết,
   - yêu cầu bảo mật/compliance cần custom behavior.

## Common Packages Trong Base

- `equatable`: value equality cho entity/state.
- `dartz`: `Either` cho error flow tường minh.
- `dio`: HTTP client nền cho network layer.
- `retrofit`: vẫn có thể dùng cho endpoint phức tạp hoặc API typed lớn.
- `BaseRemoteDataSource`: helper chung cho list/detail request đơn giản.
- `flutter_dotenv`: runtime config theo flavor.
- `melos`: command runner cho tác vụ development.
- `flutter_gen_runner`: typed asset path từ build_runner.
- `json_serializable`: setup sẵn, dùng khi cần.

## Lệnh Khuyến Nghị

```bash
dart run melos run bootstrap
dart run melos run format
dart run melos run analyze
dart run melos run test
dart run melos run gen
```

Tạo feature skeleton:

```bash
dart run melos run feature:create -- --name portfolio
```

## Quy Trình Tạo Feature

1. Tạo domain contract và use case.
2. Tạo data model, data source, repository implementation.
3. Tạo state/controller/page/widget ở presentation.
4. Đăng ký DI bằng `injectable` và resolve qua `getIt`.
5. Đăng ký route.
6. Thêm test.
7. Cập nhật docs nếu process/architecture thay đổi.

## Pull Request Checklist

- [ ] Layering đúng.
- [ ] Không import trực tiếp `data` trong `presentation`.
- [ ] Error handling dùng `Either<Failure, T>`.
- [ ] Tuân thủ quy tắc env/secrets.
- [ ] Test coverage được cập nhật.
