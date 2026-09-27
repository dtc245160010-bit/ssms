# ERD & Activity Diagram Mapping – AutoRide

Trong Activity Diagram, quy trình trả xe gồm bước kiểm tra tình trạng xe. Nếu xe bị hư hỏng, hệ thống phải ghi nhận thông tin hư hỏng và tính Damage Fee.

Trong ERD ban đầu, bảng Rentals chỉ lưu thông tin lượt thuê và trạng thái, nhưng chưa có trường để lưu Security Deposit, Late Fee và Damage Fee, đồng thời chưa có bảng Inspections để lưu chi tiết kết quả kiểm tra.

Damage Fee là trường bắt buộc vì nó ảnh hưởng trực tiếp đến số tiền hoàn trả cho khách hàng:

Refund = Security Deposit - Late Fee - Damage Fee

Nếu không lưu Damage Fee, hệ thống không thể xác định chính xác số tiền cần hoàn trả sau khi xe bị hư hỏng. Bảng Inspections được liên kết với Rentals thông qua rental_id để lưu mô tả hư hỏng và người kiểm tra.