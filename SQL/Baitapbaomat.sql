-- Tạo tài khoản 'giaodichvien01' để đăng nhập vào SQL Server
create login giaodichvien01 with password = 'P@ssword123';
go

use QLNGANHANG;
go

-- Ánh xạ Login 'giaodichvien01' thành User 'User_GDV01' trong CSDL này
create user User_GDV01 for login giaodichvien01;
go

-- Tạo một nhóm quyền (vai trò) tên là 'Role_GiaoDichVien'
create role Role_GiaoDichVien;
go

-- 1. Cấp quyền cho Role:
-- Chỉ cho phép XEM các View (đã che giấu dữ liệu ở 6.2)
grant select on v_ThongTinKhachHang_TaiKhoan to Role_GiaoDichVien;
grant select on v_NhanVien_ChiNhanh to Role_GiaoDichVien;
    
-- Chỉ cho phép THỰC THI các nghiệp vụ (không được sửa lung tung)
grant execute on sp_GuiTien to Role_GiaoDichVien;
grant execute on sp_RutTien to Role_GiaoDichVien;
go

-- 2. Chặn (DENY) các quyền nguy hiểm
-- Đây là hành động bảo mật rõ ràng nhất:
-- CHẶN quyền xem/sửa trực tiếp các bảng gốc quan trọng
deny select on TAIKHOAN to Role_GiaoDichVien;
deny update on TAIKHOAN to Role_GiaoDichVien;
deny delete on TAIKHOAN to Role_GiaoDichVien;
go

backup database QLNGANHANG
to disk = 'D:\Backup\QLNGANHANG.bak'
with 
    name = 'QLNGANHANG Full Backup',
    description = 'Bản sao lưu đầy đủ CSDL Quản lý Ngân hàng';
go

use master;
go

-- Bước 1: Chuyển CSDL về chế độ một người dùng để ngắt các kết nối
alter database QLNGANHANG
set single_user with rollback immediate;
go

-- Bước 2: Thực hiện khôi phục
restore database QLNGANHANG
from disk = 'C:\Backup\QLNGANHANG.bak'
with replace; -- REPLACE dùng để ghi đè lên CSDL hiện tại (nếu nó vẫn tồn tại)
go

-- Bước 3: Trả CSDL về chế độ đa người dùng
alter database QLNGANHANG
set multi_user;
go


-- Xây lại toàn bộ chỉ mục của bảng GIAODICH để chống phân mảnh
alter index all on GIAODICH rebuild;
go