import java.sql.*;
import java.util.Scanner;

public class BankingApp {

    // 1. Cấu hình kết nối CSDL
    // Lưu ý: Sửa 'sa' và '123456' thành tài khoản/mật khẩu SQL của bạn
    static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=QLNGANHANG;encrypt=true;trustServerCertificate=true;";
    static final String DB_USER = "giaodichvien01"; 
    static final String DB_PASSWORD = "P@ssword123"; 

// Hàm lấy kết nối (Đã sửa để kiểm tra kỹ hơn)
    public static Connection getConnection() {
        try {
            // 1. Cố gắng gọi tên "người phiên dịch" ra trước
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // 2. Nếu gọi được thì mới kết nối
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Lỗi: Chưa thêm thư viện SQL (mssql-jdbc.jar) vào dự án!");
            System.out.println("   -> Bạn hãy kiểm tra lại mục Referenced Libraries.");
            return null;
        } catch (SQLException e) {
            System.out.println("❌ Lỗi kết nối CSDL: " + e.getMessage());
            return null;
        }
    }

    // --- CHỨC NĂNG 1: HIỂN THỊ DANH SÁCH KHÁCH HÀNG ---
    public static void xemDanhSachKhachHang() {
        String sql = "SELECT * FROM KHACHHANG";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("\n--- DANH SÁCH KHÁCH HÀNG ---");
            System.out.printf("| %-5s | %-20s | %-12s | %-30s |\n", "MaKH", "Ten Khach Hang", "SDT", "Dia Chi");
            System.out.println("-------------------------------------------------------------------------------");
            
            while (rs.next()) {
                System.out.printf("| %-5d | %-20s | %-12s | %-30s |\n",
                        rs.getInt("MaKhachHang"),
                        rs.getNString("TenKhachHang"),
                        rs.getString("SoDienThoai"),
                        rs.getNString("DiaChi"));
            }
            System.out.println("-------------------------------------------------------------------------------");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- CHỨC NĂNG 2: THỰC HIỆN GIAO DỊCH (GỌI THỦ TỤC SQL) ---
    // Đây là chỗ quan trọng nhất: Phải truyền Mã Nhân Viên vào!
    public static void thucHienGiaoDich(Scanner sc) {
        System.out.println("\n--- THỰC HIỆN GIAO DỊCH GỬI TIỀN ---");
        
        System.out.print("Nhập mã tài khoản: ");
        int maTK = sc.nextInt();
        
        System.out.print("Nhập số tiền gửi: ");
        double soTien = sc.nextDouble();
        sc.nextLine(); // Xóa bộ nhớ đệm
        
        System.out.print("Nhập mã nhân viên thực hiện (VD: NV001): ");
        String maNV = sc.nextLine();

        // Gọi thủ tục sp_GuiTien chúng ta đã sửa ở trong SQL
        // Cú pháp: {call sp_GuiTien(MaTK, SoTien, MaNV)}
        String sql = "{call sp_GuiTien(?, ?, ?)}";

        try (Connection conn = getConnection();
             CallableStatement cstmt = conn.prepareCall(sql)) {

            // Truyền tham số vào dấu ?
            cstmt.setInt(1, maTK);
            cstmt.setDouble(2, soTien);
            cstmt.setString(3, maNV); // <--- QUAN TRỌNG: Truyền mã nhân viên

            // Thực thi
            cstmt.execute();
            System.out.println("✅ Giao dịch thành công! Đã ghi nhận nhân viên " + maNV + " thực hiện.");

        } catch (SQLException e) {
            System.out.println("❌ Giao dịch thất bại: " + e.getMessage());
            // Mẹo: Nếu lỗi FK, nhắc người dùng kiểm tra mã nhân viên
            if (e.getMessage().contains("FOREIGN KEY")) {
                System.out.println("=> Gợi ý: Mã nhân viên '" + maNV + "' không tồn tại trong hệ thống.");
            }
        }
    }

    // --- CHƯC NĂNG 3: XEM SAO KÊ (GỌI HÀM FUNCTION SQL) ---
    public static void xemSaoKe(Scanner sc) {
        System.out.print("\nNhập mã tài khoản cần xem sao kê: ");
        int maTK = sc.nextInt();
        sc.nextLine();

        // Gọi hàm fn_XemSaoKe(MaTK, TuNgay, DenNgay)
        String sql = "SELECT * FROM dbo.fn_XemSaoKe(?, '2023-01-01', '2025-12-31')";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, maTK);
            ResultSet rs = pstmt.executeQuery();

            System.out.println("\n--- SAO KÊ TÀI KHOẢN " + maTK + " ---");
            System.out.printf("| %-10s | %-12s | %-10s | %-15s | %-20s |\n", "MaGD", "Ngay", "Loai", "So Tien", "Nguoi Thuc Hien");
            
            while(rs.next()) {
                System.out.printf("| %-10d | %-12s | %-10s | %,15.0f | %-20s |\n",
                    rs.getInt("MaGiaoDich"),
                    rs.getDate("NgayGiaoDich"),
                    rs.getNString("LoaiGiaoDich"),
                    rs.getDouble("SoTien"),
                    rs.getNString("NguoiThucHien") // Cột mới thêm trong hàm fn_XemSaoKe
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- MAIN MENU ---
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int choice = 0;

        // Test kết nối trước
        if (getConnection() != null) {
            System.out.println("✅ Kết nối SQL Server thành công!");
        } else {
            System.out.println("❌ Không thể kết nối. Kiểm tra lại user/pass.");
            return;
        }

        while (choice != 4) {
            System.out.println("\n=== QUẢN LÝ NGÂN HÀNG (JAVA + SQL) ===");
            System.out.println("1. Xem danh sách Khách hàng");
            System.out.println("2. Gửi tiền (Yêu cầu mã Nhân viên)");
            System.out.println("3. Xem sao kê tài khoản");
            System.out.println("4. Thoát");
            System.out.print("Chọn chức năng: ");
            
            try {
                choice = sc.nextInt();
                sc.nextLine(); // Xóa buffer

                switch (choice) {
                    case 1: xemDanhSachKhachHang(); break;
                    case 2: thucHienGiaoDich(sc); break;
                    case 3: xemSaoKe(sc); break;
                    case 4: System.out.println("Tạm biệt!"); break;
                    default: System.out.println("Chọn sai, vui lòng chọn lại.");
                }
            } catch (Exception e) {
                System.out.println("Lỗi nhập liệu! Vui lòng nhập số.");
                sc.nextLine();
            }
        }
    }
}