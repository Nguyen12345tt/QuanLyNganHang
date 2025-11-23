-- Tạo index idx_TaiKhoan_MaKhachHang
create index idx_TaiKhoan_MaKhachHang
on TAIKHOAN (MaKhachHang);
go

-- Tạo index idx_GiaoDich_MaTaiKhoan
create index idx_GiaoDich_MaTaiKhoan
on GIAODICH (MaTaiKhoan);
go

-- Tạo index idx_KhachHang_SoDienThoai
create index idx_KhachHang_SoDienThoai
on KHACHHANG (SoDienThoai);
go

-- Tăng tốc bằng index
select * from KHACHHANG where SoDienThoai = '0905111222';