# Consistency Report - HealthSync

## 1. Trạng thái lịch hẹn

Cơ sở dữ liệu cũ sử dụng cột `is_active` kiểu BOOLEAN nên chỉ biểu diễn được
trạng thái hoạt động hoặc không hoạt động. Trong khi quy trình nghiệp vụ yêu
cầu 5 trạng thái: PENDING, CONFIRMED, CHECKED_IN, COMPLETED và CANCELLED.

## 2. Tiền cọc và phí phạt

Bảng Appointments ban đầu không có cột lưu tiền cọc và phí phạt. Vì vậy hệ
thống không thể ghi nhận chính xác số tiền bệnh nhân đã đặt cọc và khoản tiền
bị phạt khi hủy lịch.

## 3. Đơn thuốc

Cơ sở dữ liệu cũ không có bảng Prescriptions. Do đó sau khi lịch hẹn chuyển
sang COMPLETED, hệ thống không có nơi lưu thông tin đơn thuốc của bác sĩ.

## Kết luận

Thiết kế mới đã bổ sung trạng thái lịch hẹn, tiền cọc, phí phạt, lý do hủy
và bảng Prescriptions để dữ liệu phù hợp với quy trình nghiệp vụ của HealthSync.