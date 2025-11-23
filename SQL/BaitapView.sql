-- Tạo view v_ThongTinKhachHang_TaiKhoan
create view v_ThongTinKhachHang_TaiKhoan
as
select 
    KH.MaKhachHang, 
    KH.TenKhachHang, 
    KH.SoDienThoai, 
    KH.DiaChi, 
    TK.MaTaiKhoan, 
    TK.SoDu, 
    TK.NgayMo
from 
    KHACHHANG KH
join 
    TAIKHOAN TK on KH.MaKhachHang = TK.MaKhachHang;
go

-- Gọi view này 
select * from v_ThongTinKhachHang_TaiKhoan where TenKhachHang like N'%Nguyễn Văn An%';

-- Tạo view v_TongSoDuKhachHang
create view v_TongSoDuKhachHang
as
select 
    KH.MaKhachHang, 
    KH.TenKhachHang, 
    sum(TK.SoDu) as TongSoDu
from 
    KHACHHANG KH
join 
    TAIKHOAN TK on KH.MaKhachHang = TK.MaKhachHang
group by 
    KH.MaKhachHang, KH.TenKhachHang;
go

-- Gọi view v_TongSoDuKhachHang
select * from v_TongSoDuKhachHang;

-- Tạo view v_NhanVien_ChiNhanh
create view v_NhanVien_ChiNhanh
as
select 
    NV.MaNhanVien, 
    NV.TenNhanVien, 
    NV.ViTri, 
    CN.TenChiNhanh, 
    CN.DiaChi as DiaChiChiNhanh
from 
    NHANVIENGIAODICH NV
join 
    CHINHANH CN on NV.MaChiNhanh = CN.MaChiNhanh;
go

-- Gọi view v_NhanVien_ChiNhanh
select * from v_NhanVien_ChiNhanh where TenChiNhanh = N'Chi nhánh Hoàn Kiếm';