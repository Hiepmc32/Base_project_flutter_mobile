# fresh_base_project

Dự án base Flutter theo Bloc/Cubit + Clean Architecture.

## Tài liệu quy trình

Các tài liệu chuẩn hóa quy trình được tách riêng để team dùng chung:

- `docs/PROCESS.md`
- `docs/ARCHITECTURE.md`
- `docs/CODING_STANDARDS.md`
- `docs/FEATURE_WORKFLOW.md`
- `docs/AUTOMATION.md`
- `docs/ENV_SECURITY.md`
- `docs/TESTING.md`
- `docs/CI_CD.md`
- `docs/RESEARCH_NOTES.md`
- `CONTRIBUTING.md`

## Mục tiêu

- Không hardcode endpoint trong source code.
- Mỗi feature chia đúng 3 tầng: `presentation`, `domain`, `data`.
- Dùng `Either<Failure, T>` để xử lý lỗi tường minh qua boundary layer.
- Quản lý dependency theo feature factory + `BlocProvider`.

## Thư viện đã setup

- `flutter_bloc`: state management với Cubit/Bloc.
- `get_storage`: local storage lightweight.
- `flutter_secure_storage`: lưu token nhạy cảm (mã hóa trên thiết bị).
- `connectivity_plus`: theo dõi trạng thái mạng cho connectivity guard.
- `dio`, `cookie_jar`, `dio_cookie_manager`: network stack.
- `retrofit`: typed API client layer trên `dio`.
- `crypto`: SHA-256 hash cho SSL pinning.
- `dartz`: `Either`.
- `equatable`: so sánh value cho entity/state immutable.
- `flutter_dotenv`: env runtime theo flavor.
- `melos`: command runner để chuẩn hóa workflow.
- `freezed_annotation`, `json_annotation`: nền tảng cho model code generation.
- `build_runner`, `freezed`, `json_serializable` (dev): code generation.
- `flutter_gen_runner` (dev): generate hằng số asset, giảm hardcode path.

## Cấu trúc feature chuẩn

```text
lib/features/users/
  presentation/
    bindings/
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

## Bottom tabs cho app base

Đã thêm shell tab dưới theo hướng tham chiếu `tacoin-mobile`:

- Route mặc định `/` trỏ vào `MainTabsPage`.
- Controller tab: `lib/features/main_tabs/presentation/controllers/main_tabs_controller.dart`.
- Factory tab: `lib/features/main_tabs/presentation/bindings/main_tabs_binding.dart`.
- UI tab: `lib/features/main_tabs/presentation/pages/main_tabs_page.dart`.

Cách thay đổi nhanh khi làm dự án mới:

1. Sửa danh sách `_tabs` trong `MainTabsPage` để add/remove tab.
2. Sửa `NavigationDestination` tương ứng ở `bottomNavigationBar`.
3. Nếu nhúng feature có app bar riêng (ví dụ `UsersPage`), đặt
   `showAppBar: false` để tránh lồng `Scaffold`.

## Quy tắc dependency

- `presentation` chỉ phụ thuộc `domain`.
- `data` implement contract của `domain`.
- `domain` không import từ `data`.

## ENV theo flavor

Tạo file thật từ file mẫu:

- `env/dev.env` từ `env/dev.env.example`
- `env/uat.env` từ `env/uat.env.example`
- `env/prod.env` từ `env/prod.env.example`

`BaseRunMain` sẽ load file env theo flavor:

- `main_dev.dart` -> `env/dev.env`
- `main_uat.dart` -> `env/uat.env`
- `main_prod.dart` -> `env/prod.env`

Nếu thiếu file env, app sẽ fallback sang giá trị `--dart-define`.

Các key `network-security` theo env:

- `ENABLE_SSL_PINNING`: bật/tắt SSL pinning (mặc định trong code là `true`).
- `SSL_PINNED_SHA256`: danh sách fingerprint, phân tách bằng dấu phẩy.
- `SSL_PINNED_HOSTS`: danh sách host áp dụng pinning.
- `ENABLE_TOKEN_REFRESH_QUEUE`: bật/tắt cơ chế refresh + queue request.
- `ENABLE_CONNECTIVITY_GUARD`: chặn request khi offline.
- `AUTH_REFRESH_PATH`: endpoint refresh token.
- `AUTH_HEADER_NAME`, `AUTH_HEADER_PREFIX`: quy ước auth header.
- `AUTH_REFRESH_BODY_KEY`, `AUTH_ACCESS_TOKEN_KEY`,
  `AUTH_REFRESH_TOKEN_KEY`: key map request/response cho refresh token.

## Chạy app

```bash
flutter run -t lib/main_dev.dart
flutter run -t lib/main_uat.dart
flutter run -t lib/main_prod.dart
```

## Automation với melos

```bash
dart run melos run bootstrap
dart run melos run format
dart run melos run analyze
dart run melos run test
dart run melos run l10n
dart run melos run gen
```

Tạo skeleton feature tự động:

```bash
dart run melos run feature:create -- --name order_history
```

## Freezed / Json Serializable / Retrofit

Dependency đã có sẵn, nhưng chưa chạy code generation.

Khi bạn đồng ý, chạy:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Lệnh trên cũng generate asset constants cho `flutter_gen_runner`.

Base đã có sample `retrofit` cho feature `users`:

- `users_api_client.dart` (interface)
- `users_api_client.g.dart` (generated implementation hiện tại)

## Việc cần làm thủ công khi tạo dự án mới

1. Đổi `name`, `applicationId`, `bundle identifier` theo dự án.
2. Điền giá trị thật cho `env/<flavor>.env`.
3. Tạo feature mới bằng script:
   `dart run melos run feature:create -- --name <feature_name>`.
4. Nếu dùng model code generation, thêm annotation rồi chạy build.

## Refresh token queue

- Khi gặp `401`, chỉ một request thực hiện refresh token.
- Request đang chờ gửi trong lúc refresh sẽ được queue.
- Request `401` sẽ retry một lần sau khi refresh thành công.
- Nếu refresh thất bại, các request đang chờ sẽ fail theo lỗi auth.
- Token ưu tiên lưu/đọc bằng `flutter_secure_storage`, fallback qua
  `GetStorage`.

## Connectivity guard

- Interceptor kiểm tra kết nối trước khi gửi request.
- Khi mất mạng, request fail sớm với `DioException.connectionError`.
- Có thể bypass cho request đặc biệt bằng
  `extra[kSkipConnectivityGuard] = true`.
