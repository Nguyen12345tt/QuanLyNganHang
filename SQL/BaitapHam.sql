-- Tạo hàm LaySoDu
create function fn_LaySoDu (@MaTaiKhoan int)
returns float
as
begin
    declare @SoDu float

    select @SoDu = SoDu
    from TAIKHOAN
    where MaTaiKhoan = @MaTaiKhoan

    return @SoDu
end
go

-- Lấy số dư của tài khoản 50001
select dbo.fn_LaySoDu(50001) as SoDuHienTai;

-- Tạo hàm fn_XemSaoKe
create function fn_XemSaoKe (
    @MaTaiKhoan int,
    @TuNgay date,
    @DenNgay date
)
returns table
as
return
(
    select 
        MaGiaoDich, 
        NgayGiaoDich, 
        LoaiGiaoDich, 
        SoTien
    from 
        GIAODICH
    where 
        MaTaiKhoan = @MaTaiKhoan 
        and NgayGiaoDich between @TuNgay and @DenNgay
)
go

-- Gọi hàm fn_XemSaoKe
select * from dbo.fn_XemSaoKe(50001, '2023-10-01', '2023-10-31');