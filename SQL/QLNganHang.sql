use master;
go

if exists (select * from sysdatabases where name = 'QLNGANHANG')
	Drop database QLNGANHANG;
go

Create database QLNGANHANG;
go
use QLNGANHANG;
go

-- 1. Bảng KhachHang (Độc lập -> Tạo trước)
create table KHACHHANG (
	MaKhachHang int primary key,
	TenKhachHang nvarchar(255) not null,
	SoDienThoai varchar(12),
	DiaChi nvarchar(500)
);
go

-- 2. Bảng ChiNhanh (Độc lập -> Tạo trước)
create table CHINHANH (
	MaChiNhanh varchar(12) primary key,
	TenChiNhanh nvarchar(50),
	DiaChi nvarchar(500)
);
go

-- 3. Bảng NhanVienGiaoDich (Phụ thuộc ChiNhanh -> Tạo sau ChiNhanh)
create table NHANVIENGIAODICH (
	MaNhanVien varchar(12) primary key,
	TenNhanVien nvarchar(255) not null,
	ViTri nvarchar(500),
	MaChiNhanh varchar(12) references CHINHANH(MaChiNhanh)
);
go

-- 4. Bảng TaiKhoan (Phụ thuộc KhachHang -> Tạo sau KhachHang)
create table TAIKHOAN (
	MaTaiKhoan int primary key,
	MaKhachHang int references KHACHHANG(MaKhachHang),
	SoDu float check (SoDu >= 0),
	NgayMo date
);
go

-- 5. Bảng GiaoDich (Phụ thuộc TaiKhoan VÀ NhanVien -> Phải tạo CUỐI CÙNG)
create table GIAODICH (
	MaGiaoDich int primary key,
	MaTaiKhoan int references TAIKHOAN(MaTaiKhoan),
	MaNhanVien varchar(12) references NHANVIENGIAODICH(MaNhanVien),
	NgayGiaoDich date,
	SoTien float check (SoTien != 0),
	LoaiGiaoDich nvarchar(50) check (LoaiGiaoDich in (N'Gửi tiền', N'Rút tiền'))
);
go