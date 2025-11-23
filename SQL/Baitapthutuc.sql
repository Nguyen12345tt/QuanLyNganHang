-- Tạo thủ tục sp_GuiTien
create procedure sp_GuiTien
    @MaTaiKhoan int,
    @SoTienGui float,
    @MaNhanVien varchar(12) -- THÊM THAM SỐ NÀY
as
begin
    -- 1. Kiểm tra số tiền gửi
    if @SoTienGui <= 0
    begin
        print N'Số tiền gửi vào phải lớn hơn 0!'
        return
    end

    -- 2. Cập nhật số dư
    update TAIKHOAN
    set SoDu = SoDu + @SoTienGui
    where MaTaiKhoan = @MaTaiKhoan

    -- 3. Ghi lịch sử giao dịch (CÓ THÊM MaNhanVien)
    declare @MaGiaoDichMoi int
    select @MaGiaoDichMoi = isnull(max(MaGiaoDich), 0) + 1 from GIAODICH
    
    insert into GIAODICH (MaGiaoDich, MaTaiKhoan, MaNhanVien, NgayGiaoDich, SoTien, LoaiGiaoDich)
    values (@MaGiaoDichMoi, @MaTaiKhoan, @MaNhanVien, getdate(), @SoTienGui, N'Gửi tiền')
    
    print N'Gửi tiền thành công!'
end
go

-- Nhân viên NV001 thực hiện gửi tiền
exec sp_GuiTien @MaTaiKhoan = 50001, @SoTienGui = 1000000, @MaNhanVien = 'NV001';

-- Tạo thủ tục sp_RutTien
create procedure sp_RutTien
    @MaTaiKhoan int,
    @SoTienRut float,
    @MaNhanVien varchar(12) -- THÊM THAM SỐ NÀY
as
begin
    -- 1. Kiểm tra số tiền rút
    if @SoTienRut <= 0
    begin
        print N'Số tiền rút phải lớn hơn 0!'
        return
    end

    -- 2. Kiểm tra số dư
    declare @SoDuHienTai float
    select @SoDuHienTai = SoDu from TAIKHOAN where MaTaiKhoan = @MaTaiKhoan
    
    if @SoDuHienTai < @SoTienRut
    begin
        print N'Số dư không đủ để thực hiện giao dịch!'
        return
    end
    
    -- 3. Cập nhật số dư
    update TAIKHOAN
    set SoDu = SoDu - @SoTienRut
    where MaTaiKhoan = @MaTaiKhoan

    -- 4. Ghi lịch sử giao dịch (CÓ THÊM MaNhanVien)
    declare @MaGiaoDichMoi int
    select @MaGiaoDichMoi = isnull(max(MaGiaoDich), 0) + 1 from GIAODICH
    
    insert into GIAODICH (MaGiaoDich, MaTaiKhoan, MaNhanVien, NgayGiaoDich, SoTien, LoaiGiaoDich)
    values (@MaGiaoDichMoi, @MaTaiKhoan, @MaNhanVien, getdate(), -@SoTienRut, N'Rút tiền')
    
    print N'Rút tiền thành công!'
end
go

-- Nhân viên NV002 thực hiện rút tiền
exec sp_RutTien @MaTaiKhoan = 50002, @SoTienRut = 500000, @MaNhanVien = 'NV002';