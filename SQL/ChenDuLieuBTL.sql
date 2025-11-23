-- 1. Chèn dữ liệu cho bảng CHINHANH (Tạo đầu tiên)
insert into CHINHANH (MaChiNhanh, TenChiNhanh, DiaChi) values
('CN_HN01', N'Chi nhánh Hoàn Kiếm', N'1 Lý Thái Tổ, Hoàn Kiếm, Hà Nội'),
('CN_HCM01', N'Chi nhánh Quận 1', N'1 Nguyễn Huệ, Quận 1, TPHCM'),
('CN_DN01', N'Chi nhánh Hải Châu', N'2 Bạch Đằng, Hải Châu, Đà Nẵng');
go

-- 2. Chèn dữ liệu cho bảng NHANVIENGIAODICH (Phụ thuộc ChiNhanh)
insert into NHANVIENGIAODICH (MaNhanVien, TenNhanVien, ViTri, MaChiNhanh) values
('NV001', N'Trần Minh Anh', N'Giao dịch viên', 'CN_HN01'),
('NV002', N'Nguyễn Hoàng Long', N'Trưởng phòng giao dịch', 'CN_HN01'),
('NV003', N'Lê Thị Bích', N'Giao dịch viên', 'CN_HCM01'),
('NV004', N'Phạm Văn Cường', N'Giao dịch viên', 'CN_DN01');
go

-- 3. Chèn dữ liệu cho bảng KHACHHANG (Độc lập)
insert into KHACHHANG (MaKhachHang, TenKhachHang, SoDienThoai, DiaChi) values
(1001, N'Nguyễn Văn An', '0905111222', N'123 Trần Phú, Hà Nội'),
(1002, N'Trần Thị Lan', '0913222333', N'456 Lê Lợi, TPHCM'),
(1003, N'Lê Văn Hùng', '0987333444', N'789 Nguyễn Chí Thanh, Đà Nẵng');
go

-- 4. Chèn dữ liệu cho bảng TAIKHOAN (Phụ thuộc KhachHang)
insert into TAIKHOAN (MaTaiKhoan, MaKhachHang, SoDu, NgayMo) values
(50001, 1001, 15000000.0, '2022-01-15'),
(50002, 1002, 120000000.0, '2021-06-30'),
(50003, 1003, 7500000.0, '2023-03-01'),
(50004, 1001, 2500000.0, '2023-05-20');
go

-- 5. Chèn dữ liệu cho bảng GIAODICH
insert into GIAODICH (MaGiaoDich, MaTaiKhoan, MaNhanVien, NgayGiaoDich, SoTien, LoaiGiaoDich) values
(90001, 50001, 'NV001', '2023-10-01', 5000000.0, N'Gửi tiền'),   -- NV001 thực hiện
(90002, 50001, 'NV001', '2023-10-05', -2000000.0, N'Rút tiền'),   -- NV001 thực hiện
(90003, 50002, 'NV003', '2023-10-02', 20000000.0, N'Gửi tiền'),   -- NV003 (HCM) thực hiện
(90004, 50003, 'NV004', '2023-10-03', -1000000.0, N'Rút tiền'),   -- NV004 (ĐN) thực hiện
(90005, 50004, 'NV001', '2023-10-04', 2500000.0, N'Gửi tiền');    -- NV001 thực hiện
go