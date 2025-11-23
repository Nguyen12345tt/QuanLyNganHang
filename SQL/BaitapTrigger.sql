-- Tạo trigger trig_NganChanXoaTaiKhoan
create trigger trg_NganChanXoaTaiKhoan
on TAIKHOAN
for delete
as
begin
    -- 'deleted' là một bảng ảo đặc biệt, chứa các dòng vừa bị xóa
    if exists (select 1 from deleted where SoDu > 0)
    begin
        -- Nếu có bất kỳ tài khoản nào bị xóa mà SoDu > 0
        print N'Lỗi nghiệp vụ: Không thể xóa tài khoản vì vẫn còn số dư!'

        -- Hủy bỏ hành động DELETE
        rollback transaction
    end
end
go

-- Câu lệnh gọi trigger (thử xóa và bị chặn): 
-- Dựa trên dữ liệu mẫu, tài khoản 50001 đang có 15.000.000. Ta thử xóa nó:
-- Lệnh (vượt qua Lớp 1):
delete from GIAODICH where MaTaiKhoan = 50001;
go

-- Lệnh (kích hoạt Lớp 2 - Trigger):
delete from TAIKHOAN where MaTaiKhoan = 50001;
go

-- Lệnh qua lớp 2 (Trigger)
update TAIKHOAN set SoDu = 0 where MaTaiKhoan = 50001;

-- Lệnh qua lớp 1
delete from GIAODICH where MaTaiKhoan = 50001;

-- Lệnh xóa thành công
delete from TAIKHOAN where MaTaiKhoan = 50001;


-- Tạo trigger trg_ChanCapNhatGiaoDich 
create trigger trg_ChanCapNhatGiaoDich
on GIAODICH
for update -- Kích hoạt khi có lệnh UPDATE
as
begin
    print N'Lỗi: Không được phép sửa đổi lịch sử giao dịch đã hoàn tất!'

    -- Hủy bỏ ngay lập tức hành động UPDATE
    rollback transaction
end
go

-- Câu lệnh gọi trigger
update GIAODICH
set SoTien = 8000000 -- Cố gắng sửa số tiền
where MaGiaoDich = 90001;
