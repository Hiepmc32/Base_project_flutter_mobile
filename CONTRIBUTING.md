# Hướng Dẫn Contributing

## Đọc Trước Khi Làm

Trước khi bắt đầu implement, hãy đọc:

1. `docs/PROCESS.md`
2. `docs/ARCHITECTURE.md`
3. `docs/CODING_STANDARDS.md`

## Branch và Pull Request

1. Tạo branch `feature/` hoặc `fix/` từ `main`.
2. Giữ phạm vi Pull Request nhỏ, tập trung một mục tiêu.
3. Ghi rõ bằng chứng test trong mô tả Pull Request.

## Checklist Trước Khi Mở Pull Request

- [ ] `dart run melos run format`
- [ ] `dart run melos run analyze`
- [ ] `dart run melos run test`
- [ ] Cập nhật docs nếu process/architecture thay đổi

## Quy Tắc Code Generation

Không chạy `build_runner` nếu chưa có xác nhận từ project owner.
