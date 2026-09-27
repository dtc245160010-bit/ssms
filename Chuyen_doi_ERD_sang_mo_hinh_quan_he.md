# Chuyển đổi ERD sang mô hình dữ liệu quan hệ

## Bước 1: Xác định các thực thể

Từ mô hình ERD, xác định các thực thể:

1. PHIEUXUAT(SoPX, NgayXuat)
2. VATTU(MaVTU, TenVTU)
3. PHIEUNHAP(SoPN, NgayNhap)
4. DONDH(SoDH, NgayDH)
5. NHACC(MaNCC, TenNCC, DiaChi, SDT)

Trong đó khóa chính:
- PHIEUXUAT: SoPX
- VATTU: MaVTU
- PHIEUNHAP: SoPN
- DONDH: SoDH
- NHACC: MaNCC

## Bước 2: Xác định các mối quan hệ

1. PHIEUXUAT - VATTU: quan hệ N:N (Chi tiết phiếu xuất).
2. PHIEUNHAP - VATTU: quan hệ N:N (Chi tiết phiếu nhập).
3. DONDH - VATTU: quan hệ N:N (Chi tiết đơn đặt hàng).
4. DONDH - NHACC: quan hệ N:1 (Cung cấp).

## Bước 3: Chuyển đổi các quan hệ N:N

### CHITIETPHIEUXUAT

CHITIETPHIEUXUAT(SoPX, MaVTU, DGXuat, SLXuat)

- Khóa chính: (SoPX, MaVTU)
- SoPX là khóa ngoại tham chiếu PHIEUXUAT(SoPX)
- MaVTU là khóa ngoại tham chiếu VATTU(MaVTU)

### CHITIETPHIEUNHAP

CHITIETPHIEUNHAP(SoPN, MaVTU, DGNhap, SLNhap)

- Khóa chính: (SoPN, MaVTU)
- SoPN là khóa ngoại tham chiếu PHIEUNHAP(SoPN)
- MaVTU là khóa ngoại tham chiếu VATTU(MaVTU)

### CHITIETDONDH

CHITIETDONDH(SoDH, MaVTU)

- Khóa chính: (SoDH, MaVTU)
- SoDH là khóa ngoại tham chiếu DONDH(SoDH)
- MaVTU là khóa ngoại tham chiếu VATTU(MaVTU)

## Bước 4: Chuyển đổi quan hệ 1:N

Quan hệ DONDH - NHACC là N:1.

Đưa khóa chính MaNCC của NHACC sang DONDH:

DONDH(SoDH, NgayDH, MaNCC)

Trong đó MaNCC là khóa ngoại tham chiếu NHACC(MaNCC).

## Bước 5: Xử lý thuộc tính đa trị

SDT của NHACC là thuộc tính đa trị nên tạo bảng riêng:

### SDTNHACC

SDTNHACC(MaNCC, SDT)

- Khóa chính: (MaNCC, SDT)
- MaNCC là khóa ngoại tham chiếu NHACC(MaNCC)

## Bước 6: Danh sách các bảng sau khi chuyển đổi

### 1. PHIEUXUAT
PHIEUXUAT(SoPX PK, NgayXuat)

### 2. VATTU
VATTU(MaVTU PK, TenVTU)

### 3. PHIEUNHAP
PHIEUNHAP(SoPN PK, NgayNhap)

### 4. DONDH
DONDH(SoDH PK, NgayDH, MaNCC FK)

### 5. NHACC
NHACC(MaNCC PK, TenNCC, DiaChi)

### 6. CHITIETPHIEUXUAT
CHITIETPHIEUXUAT(SoPX PK/FK, MaVTU PK/FK, DGXuat, SLXuat)

### 7. CHITIETPHIEUNHAP
CHITIETPHIEUNHAP(SoPN PK/FK, MaVTU PK/FK, DGNhap, SLNhap)

### 8. CHITIETDONDH
CHITIETDONDH(SoDH PK/FK, MaVTU PK/FK)

### 9. SDTNHACC
SDTNHACC(MaNCC PK/FK, SDT PK)

## Kết luận

Sau khi chuyển đổi mô hình ERD sang mô hình dữ liệu quan hệ, thu được 9 bảng. Các quan hệ N:N được chuyển thành bảng trung gian, quan hệ N:1 được đưa khóa ngoại từ phía 1 sang phía N, và thuộc tính đa trị SDT được tách thành một bảng riêng.
