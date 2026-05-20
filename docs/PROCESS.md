# Quy Trình Chuẩn (Bloc/Cubit + Clean Architecture)

Tài liệu này mô tả quy trình thực thi ở cấp team cho base project.

## 1) Chốt Scope Trước Khi Code

1. Chốt scope feature, acceptance criteria, target platform.
2. Chốt API contract (request/response, error code, fallback behavior).
3. Chốt non-functional constraint (performance, security, timeline).

## 2) Quy Tắc Architecture (Bắt Buộc)

1. Mọi feature phải nằm trong `lib/features/<feature_name>/`.
2. Giữ đúng chiều dependency:
   - `presentation` -> `domain` <- `data`
3. `domain` không được import từ `data`.
4. Dùng `Either<Failure, T>` qua boundary của `domain` và `data`.
5. Dùng `go_router` + Bloc/Cubit cho routing và presentation state.
6. Dùng `get_it` + `injectable` cho dependency injection.

## 3) Thứ Tự Implement

1. Tạo domain contract trước:
   - `entities`, `repositories`, `usecases`
2. Implement data layer:
   - `datasources`, `models`, `repositories_impl`
3. Implement presentation layer:
   - `controllers` (Cubit/Bloc), `state`, `pages`, `widgets`
4. Đăng ký DI trong `locator.dart` hoặc thêm annotation để generate vào `locator.config.dart`.
5. Đăng ký route trong `lib/core/utils/ui/app_router.dart`.
6. Thêm key đa ngôn ngữ vào ARB.

## 4) Validation Trước Pull Request

1. Chạy formatter.
2. Chạy analyzer.
3. Chạy test.
4. Verify env setup theo từng flavor.
5. Verify không có secret trong source và env example.

Lệnh khuyến nghị:

- `dart run melos run format`
- `dart run melos run analyze`
- `dart run melos run test`

## 5) Definition of Done

Một task chỉ được coi là hoàn thành khi:

1. Layer boundary đúng.
2. Error flow tường minh bằng `Failure`.
3. Public API có tài liệu `///` khi cần.
4. Test được thêm/cập nhật.
5. README/docs được cập nhật nếu hành vi thay đổi.
6. CI pass.

## 6) Các Shortcut Bị Cấm

1. Không import trực tiếp `data` từ `presentation`.
2. Không throw lỗi từ domain trong normal flow.
3. Không hardcode endpoint hoặc secret.
4. Không chạy `build_runner` khi chưa có approval rõ ràng.
