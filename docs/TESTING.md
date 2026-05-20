# Testing Strategy

## Loại Test

1. Unit test cho domain use case và repository mapping.
2. Widget test cho màn hình và widget quan trọng.
3. Integration test cho user flow quan trọng.

## Mức Coverage Tối Thiểu

- Use case mới: phải có unit test.
- Controller/state flow không đơn giản: có unit hoặc widget test.
- Flow quan trọng (login/payment/order): có integration test.

## Test Pattern

Dùng Arrange -> Act -> Assert.

## Lệnh Thực Tế

```bash
flutter test
```

Nếu có integration test:

```bash
flutter test integration_test
```
