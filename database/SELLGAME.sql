Create database SELLGAME;
go
use SELLGAME;
go

CREATE TABLE TaiKhoan (
  id INT PRIMARY KEY IDENTITY(1,1),
  ho_ten NVARCHAR(100) NOT NULL,
  email NVARCHAR(100) NOT NULL UNIQUE,
  mat_khau NVARCHAR(100) NOT NULL,
  so_dien_thoai NVARCHAR(20),
  dia_chi NVARCHAR(255),
  avatar NVARCHAR(255),
  vai_tro NVARCHAR(20) NOT NULL,      -- ADMIN, CUSTOMER
  trang_thai NVARCHAR(20) NOT NULL,   -- ACTIVE, INACTIVE, BANNED
  ngay_tao DATETIME DEFAULT GETDATE(),
  last_login DATETIME
);
go

CREATE TABLE KhachHang (
  id INT PRIMARY KEY IDENTITY(1,1),
  id_tai_khoan INT NOT NULL UNIQUE,
  ngay_sinh DATE,
  gioi_tinh NVARCHAR(10),
  FOREIGN KEY (id_tai_khoan) REFERENCES TaiKhoan(id)
);
go

CREATE TABLE DanhMuc (
  id INT PRIMARY KEY IDENTITY(1,1),
  ten_danh_muc NVARCHAR(100) NOT NULL,
  slug NVARCHAR(100) UNIQUE,
  mo_ta NVARCHAR(255)
);
go

CREATE TABLE Game (
  id INT PRIMARY KEY IDENTITY(1,1),
  id_danh_muc INT NOT NULL,
  
  -- Thông tin cơ bản
  ten_game NVARCHAR(255) NOT NULL,
  
  -- Hình ảnh & Video
  anh_bia NVARCHAR(255),
  anh_screenshots NVARCHAR(4000),
  
  -- Thông tin phát hành
  nha_phat_hanh NVARCHAR(255),
  ngay_phat_hanh DATE,
  
  -- Phân loại
  the_loai NVARCHAR(500),
  
  -- Yêu cầu hệ thống
  yeu_cau_toi_thieu NVARCHAR(1000),
  yeu_cau_de_xuat NVARCHAR(1000),
  
  -- Link Download
  link_download NVARCHAR(500) NOT NULL,
  dung_luong NVARCHAR(50),
  phien_ban NVARCHAR(50),
  
  -- Giá cả
  gia_goc DECIMAL(18,2) NOT NULL,
  gia_vnd DECIMAL(18,2) NOT NULL,
  gia_giam DECIMAL(18,2),
  phan_tram_giam INT DEFAULT 0,
  
  -- Thống kê
  luot_mua INT DEFAULT 0,
  
  -- Trạng thái
  trang_thai NVARCHAR(50) NOT NULL,
  ngay_tao DATETIME DEFAULT GETDATE(),
  ngay_cap_nhat DATETIME,
  
  FOREIGN KEY (id_danh_muc) REFERENCES DanhMuc(id)
);
go

CREATE TABLE KhuyenMai (
  id INT PRIMARY KEY IDENTITY(1,1),
  ten_khuyen_mai NVARCHAR(100) NOT NULL,
  ma_giam_gia NVARCHAR(50) UNIQUE,
  gia_tri_giam DECIMAL(18,2) NOT NULL,
  
  ap_dung_cho NVARCHAR(50),                   -- ALL_GAMES, SPECIFIC_GAMES, CATEGORY
  danh_sach_game NVARCHAR(4000),               -- JSON array id game
  id_danh_muc INT NULL,
  so_luong INT,
  da_dung INT DEFAULT 0,
  
  ngay_bat_dau DATETIME NOT NULL,
  ngay_ket_thuc DATETIME NOT NULL,
  
  trang_thai NVARCHAR(50) NOT NULL,
  
  FOREIGN KEY (id_danh_muc) REFERENCES DanhMuc(id)
);
go

CREATE TABLE HoaDon (
  id INT PRIMARY KEY IDENTITY(1,1),
  id_khach_hang INT NOT NULL,
  id_khuyen_mai INT NULL,
  
  ma_hoa_don NVARCHAR(50) UNIQUE,
  ngay_lap DATETIME DEFAULT GETDATE(),
  tong_tien DECIMAL(18,2) NOT NULL,
  tien_giam DECIMAL(18,2) DEFAULT 0,
  thanh_tien DECIMAL(18,2) NOT NULL,
  trang_thai NVARCHAR(50) NOT NULL,           -- CHO_THANH_TOAN, DA_THANH_TOAN, DA_HUY
  phuong_thuc_thanh_toan NVARCHAR(50),
  ma_giao_dich NVARCHAR(100),
  thong_tin_thanh_toan NVARCHAR(1000),
  
  ghi_chu NVARCHAR(500),
  
  FOREIGN KEY (id_khach_hang) REFERENCES KhachHang(id),
  FOREIGN KEY (id_khuyen_mai) REFERENCES KhuyenMai(id)
);
go

CREATE TABLE ChiTietHoaDon (
  id INT PRIMARY KEY IDENTITY(1,1),
  id_hoa_don INT NOT NULL,
  id_game INT NOT NULL,
  so_luong INT NOT NULL DEFAULT 1,
  gia_ban DECIMAL(18,2) NOT NULL,
  thanh_tien DECIMAL(18,2) NOT NULL,
  FOREIGN KEY (id_hoa_don) REFERENCES HoaDon(id),
  FOREIGN KEY (id_game) REFERENCES Game(id)
);
go

-- =====================================================
-- INSERT DỮ LIỆU MẪU CHO DATABASE SELLGAME
-- =====================================================
USE SELLGAME;
GO

-- =====================================================
-- 1. INSERT BẢNG TAIKHOAN (10 tài khoản)
-- =====================================================
INSERT INTO TaiKhoan (ho_ten, email, mat_khau, so_dien_thoai, dia_chi, avatar, vai_tro, trang_thai, last_login)
VALUES
(N'Nguyễn Văn An', 'an.nguyen@email.com', '123456', '0901234567', N'123 Lê Lợi, Q1, TP.HCM', 'avatar1.jpg', 'CUSTOMER', 'ACTIVE', GETDATE()),
(N'Trần Thị Bình', 'binh.tran@email.com', '123456', '0902234567', N'456 Nguyễn Huệ, Q1, TP.HCM', 'avatar2.jpg', 'CUSTOMER', 'ACTIVE', GETDATE()),
(N'Lê Văn Cường', 'cuong.le@email.com', '123456', '0903234567', N'789 Cách Mạng Tháng 8, Q3, TP.HCM', 'avatar3.jpg', 'CUSTOMER', 'ACTIVE', GETDATE()),
(N'Phạm Thị Dung', 'dung.pham@email.com', '123456', '0904234567', N'321 Võ Văn Tần, Q3, TP.HCM', 'avatar4.jpg', 'CUSTOMER', 'ACTIVE', GETDATE()),
(N'Hoàng Văn Em', 'em.hoang@email.com', '123456', '0905234567', N'654 Nguyễn Đình Chiểu, Q3, TP.HCM', 'avatar5.jpg', 'CUSTOMER', 'INACTIVE', NULL),
(N'Đỗ Thị Phương', 'phuong.do@email.com', '123456', '0906234567', N'987 Hai Bà Trưng, Q1, TP.HCM', 'avatar6.jpg', 'CUSTOMER', 'ACTIVE', GETDATE()),
(N'Vũ Văn Giang', 'giang.vu@email.com', '123456', '0907234567', N'147 Điện Biên Phủ, Bình Thạnh, TP.HCM', 'avatar7.jpg', 'CUSTOMER', 'ACTIVE', GETDATE()),
(N'Ngô Thị Hương', 'huong.ngo@email.com', '123456', '0908234567', N'258 Phạm Văn Đồng, Thủ Đức, TP.HCM', 'avatar8.jpg', 'CUSTOMER', 'BANNED', NULL),
(N'Đặng Văn Inh', 'inh.dang@email.com', '123456', '0909234567', N'369 Quang Trung, Gò Vấp, TP.HCM', 'avatar9.jpg', 'CUSTOMER', 'ACTIVE', GETDATE()),
(N'Bùi Thị Kim', 'kim.bui@email.com', '123456', '0910234567', N'741 Lê Văn Việt, Thủ Đức, TP.HCM', 'avatar10.jpg', 'ADMIN', 'ACTIVE', GETDATE());
GO

-- =====================================================
-- 2. INSERT BẢNG KHACHHANG (10 khách hàng)
-- =====================================================
INSERT INTO KhachHang (id_tai_khoan, ngay_sinh, gioi_tinh)
VALUES
(1, '1990-05-15', N'Nam'),
(2, '1992-08-20', N'Nữ'),
(3, '1988-03-10', N'Nam'),
(4, '1995-11-25', N'Nữ'),
(5, '1985-07-30', N'Nam'),
(6, '1993-12-12', N'Nữ'),
(7, '1991-04-18', N'Nam'),
(8, '1994-09-05', N'Nữ'),
(9, '1989-06-22', N'Nam'),
(10, '1996-02-14', N'Nữ');
GO

-- =====================================================
-- 3. INSERT BẢNG DANHMUC (10 danh mục)
-- =====================================================
INSERT INTO DanhMuc (ten_danh_muc, slug, mo_ta)
VALUES
(N'Hành động', 'hanh-dong', N'Các game hành động kịch tính, bắn súng, đánh nhau'),
(N'Phiêu lưu', 'phieu-luu', N'Game phiêu lưu, khám phá thế giới mở'),
(N'Nhập vai', 'nhap-vai', N'Game nhập vai, xây dựng nhân vật'),
(N'Thể thao', 'the-thao', N'Game bóng đá, bóng rổ, đua xe'),
(N'Chiến thuật', 'chien-thuat', N'Game chiến thuật, quản lý đội hình'),
(N'Mô phỏng', 'mo-phong', N'Game mô phỏng cuộc sống, kinh doanh'),
(N'Kinh dị', 'kinh-di', N'Game kinh dị, sinh tồn'),
(N'Indie', 'indie', N'Game độc lập, sáng tạo'),
(N'Đua xe', 'dua-xe', N'Game đua xe tốc độ cao'),
(N'Giải đố', 'giai-do', N'Game giải đố, trí tuệ');
GO

-- =====================================================
-- 4. INSERT BẢNG GAME (10 game)
-- =====================================================
INSERT INTO Game (
    id_danh_muc, ten_game, anh_bia, anh_screenshots, nha_phat_hanh, ngay_phat_hanh,
    the_loai, yeu_cau_toi_thieu, yeu_cau_de_xuat, link_download, dung_luong, phien_ban,
    gia_goc, gia_vnd, gia_giam, phan_tram_giam, luot_mua, trang_thai, ngay_cap_nhat
)
VALUES
(1, N'Cyberpunk 2077', 'cyberpunk.jpg', N'["cp1.jpg","cp2.jpg","cp3.jpg"]', N'CD Projekt', '2020-12-10',
 N'["Hanh dong","Nhap vai"]', N'CPU: i5-3570K, RAM: 8GB, GPU: GTX 780', N'CPU: i7-6700, RAM: 16GB, GPU: RTX 2060',
 N'https://download.game.com/cyberpunk', '70GB', '2.1', 1500000, 1500000, 1200000, 20, 1500, 'ON_SALE', GETDATE()),

(2, N'Red Dead Redemption 2', 'rdr2.jpg', N'["rdr1.jpg","rdr2.jpg"]', N'Rockstar Games', '2019-11-05',
 N'["Phieu luu","Hanh dong"]', N'CPU: i5-2500K, RAM: 8GB, GPU: GTX 770', N'CPU: i7-4770K, RAM: 12GB, GPU: GTX 1060',
 N'https://download.game.com/rdr2', '120GB', '1.0', 1200000, 1200000, 900000, 25, 2500, 'ON_SALE', GETDATE()),

(3, N'The Witcher 3', 'witcher3.jpg', N'["wt1.jpg","wt2.jpg"]', N'CD Projekt', '2015-05-19',
 N'["Nhap vai","Hanh dong"]', N'CPU: i5-2500K, RAM: 6GB, GPU: GTX 660', N'CPU: i7-3770, RAM: 8GB, GPU: GTX 970',
 N'https://download.game.com/witcher3', '50GB', '3.7', 500000, 500000, 350000, 30, 3000, 'ON_SALE', GETDATE()),

(4, N'FIFA 24', 'fifa24.jpg', N'["fifa1.jpg","fifa2.jpg"]', N'EA Sports', '2023-09-29',
 N'["The thao"]', N'CPU: i5-6600K, RAM: 8GB, GPU: GTX 1050 Ti', N'CPU: i7-8700, RAM: 16GB, GPU: RTX 2060',
 N'https://download.game.com/fifa24', '45GB', '1.0', 1000000, 1000000, 1000000, 0, 800, 'ON_SALE', GETDATE()),

(1, N'Call of Duty: MW2', 'codmw2.jpg', N'["cod1.jpg","cod2.jpg"]', N'Activision', '2022-10-28',
 N'["Hanh dong","Ban sung"]', N'CPU: i5-6600K, RAM: 8GB, GPU: GTX 960', N'CPU: i7-9700K, RAM: 16GB, GPU: RTX 2070',
 N'https://download.game.com/codmw2', '80GB', '1.2', 1400000, 1400000, 1120000, 20, 2000, 'ON_SALE', GETDATE()),

(5, N'Age of Empires IV', 'aoe4.jpg', N'["aoe1.jpg","aoe2.jpg"]', N'Microsoft', '2021-10-28',
 N'["Chien thuat"]', N'CPU: i5-6300U, RAM: 8GB, GPU: HD 520', N'CPU: i7-8700K, RAM: 16GB, GPU: GTX 1060',
 N'https://download.game.com/aoe4', '50GB', '1.0', 800000, 800000, 800000, 0, 500, 'ON_SALE', GETDATE()),

(6, N'The Sims 4', 'sims4.jpg', N'["sims1.jpg","sims2.jpg"]', N'EA', '2014-09-02',
 N'["Mo phong"]', N'CPU: Core 2 Duo, RAM: 4GB, GPU: GMA 4500', N'CPU: i5-3470, RAM: 8GB, GPU: GTX 650',
 N'https://download.game.com/sims4', '25GB', '1.0', 400000, 400000, 200000, 50, 4000, 'ON_SALE', GETDATE()),

(7, N'Resident Evil 4', 're4.jpg', N'["re1.jpg","re2.jpg"]', N'Capcom', '2023-03-24',
 N'["Kinh di","Sinh ton"]', N'CPU: i5-7500, RAM: 8GB, GPU: GTX 1050 Ti', N'CPU: i7-8700, RAM: 16GB, GPU: RTX 2060',
 N'https://download.game.com/re4', '60GB', '1.0', 900000, 900000, 720000, 20, 1200, 'ON_SALE', GETDATE()),

(8, N'Hollow Knight', 'hollow.jpg', N'["hk1.jpg","hk2.jpg"]', N'Team Cherry', '2017-02-24',
 N'["Indie","Phieu luu"]', N'CPU: Core 2 Duo, RAM: 4GB, GPU: Intel HD', N'CPU: i3, RAM: 8GB, GPU: GT 1030',
 N'https://download.game.com/hollow', '9GB', '1.5', 200000, 200000, 160000, 20, 2500, 'ON_SALE', GETDATE()),

(9, N'Forza Horizon 5', 'forza5.jpg', N'["forza1.jpg","forza2.jpg"]', N'Microsoft', '2021-11-09',
 N'["Dua xe"]', N'CPU: i5-8400, RAM: 8GB, GPU: GTX 970', N'CPU: i7-10700K, RAM: 16GB, GPU: RTX 3070',
 N'https://download.game.com/forza5', '110GB', '1.0', 1300000, 1300000, 975000, 25, 1500, 'ON_SALE', GETDATE());
GO

-- =====================================================
-- 5. INSERT BẢNG KHUYENMAI (10 khuyến mãi)
-- =====================================================
INSERT INTO KhuyenMai (
    ten_khuyen_mai, ma_giam_gia, gia_tri_giam, ap_dung_cho, danh_sach_game, id_danh_muc,
    so_luong, da_dung, ngay_bat_dau, ngay_ket_thuc, trang_thai
)
VALUES
(N'Giảm 20% game hành động', 'ACTION20', 20, 'CATEGORY', NULL, 1, 100, 10, '2024-01-01', '2024-12-31', 'ACTIVE'),
(N'Giảm 50K đơn đầu tiên', 'NEW50K', 50000, 'ALL_GAMES', NULL, NULL, 200, 30, '2024-01-01', '2024-06-30', 'ACTIVE'),
(N'Giảm 30% Cyberpunk', 'CYBER30', 30, 'SPECIFIC_GAMES', '[1]', NULL, 50, 15, '2024-02-01', '2024-03-01', 'EXPIRED'),
(N'Giảm 15% game thể thao', 'SPORT15', 15, 'CATEGORY', NULL, 4, 150, 20, '2024-01-15', '2024-05-15', 'ACTIVE'),
(N'Giảm 100K game nhập vai', 'RPG100K', 100000, 'CATEGORY', NULL, 3, 80, 10, '2024-02-01', '2024-04-30', 'ACTIVE'),
(N'Giảm 40% FIFA 24', 'FIFA40', 40, 'SPECIFIC_GAMES', '[4]', NULL, 30, 5, '2024-03-01', '2024-03-15', 'EXPIRED'),
(N'Giảm 10% tất cả game', 'ALL10', 10, 'ALL_GAMES', NULL, NULL, 500, 120, '2024-01-01', '2024-06-30', 'ACTIVE'),
(N'Giảm 25% game indie', 'INDIE25', 25, 'CATEGORY', NULL, 8, 100, 8, '2024-02-15', '2024-04-15', 'ACTIVE'),
(N'Giảm 60K game kinh dị', 'HORROR60K', 60000, 'CATEGORY', NULL, 7, 60, 2, '2024-03-01', '2024-03-31', 'EXPIRED'),
(N'Giảm 35% game đua xe', 'RACE35', 35, 'CATEGORY', NULL, 9, 70, 5, '2024-02-01', '2024-03-30', 'EXPIRED');
GO

-- =====================================================
-- 6. INSERT BẢNG HOADON (10 hóa đơn)
-- =====================================================
INSERT INTO HoaDon (
    id_khach_hang, id_khuyen_mai, ma_hoa_don, ngay_lap,
    tong_tien, tien_giam, thanh_tien, trang_thai, phuong_thuc_thanh_toan, ma_giao_dich, thong_tin_thanh_toan, ghi_chu
)
VALUES
(1, 2, 'HD-20240101-001', '2024-01-01 10:30:00', 1500000, 50000, 1450000, 'DA_THANH_TOAN', 'MB_BANK', 'MB123456', N'{"bank":"MB"}', N'Thanh toan thanh cong'),
(2, 7, 'HD-20240102-002', '2024-01-02 14:20:00', 1200000, 120000, 1080000, 'DA_THANH_TOAN', 'MB_BANK', 'MB789012', N'{"bank":"MB"}', N'Khach hang moi'),
(3, NULL, 'HD-20240103-003', '2024-01-03 09:15:00', 500000, 0, 500000, 'DA_THANH_TOAN', 'MB_BANK', 'MB345678', N'{"bank":"MB"}', N''),
(4, 1, 'HD-20240104-004', '2024-01-04 16:45:00', 1400000, 280000, 1120000, 'DA_THANH_TOAN', 'MB_BANK', 'MB901234', N'{"bank":"MB"}', N''),
(5, NULL, 'HD-20240105-005', '2024-01-05 11:30:00', 800000, 0, 800000, 'CHO_THANH_TOAN', NULL, NULL, NULL, N'Cho thanh toan'),
(6, 3, 'HD-20240106-006', '2024-01-06 13:10:00', 1500000, 450000, 1050000, 'DA_THANH_TOAN', 'MB_BANK', 'MB567890', N'{"bank":"MB"}', N''),
(7, 5, 'HD-20240107-007', '2024-01-07 08:30:00', 900000, 100000, 800000, 'DA_THANH_TOAN', 'MB_BANK', 'MB123789', N'{"bank":"MB"}', N''),
(8, NULL, 'HD-20240108-008', '2024-01-08 17:20:00', 400000, 0, 400000, 'DA_HUY', NULL, NULL, NULL, N'Khach huy don'),
(9, 4, 'HD-20240109-009', '2024-01-09 10:00:00', 1300000, 195000, 1105000, 'DA_THANH_TOAN', 'MB_BANK', 'MB456123', N'{"bank":"MB"}', N''),
(10, 1, 'HD-20240110-010', '2024-01-10 15:45:00', 1000000, 200000, 800000, 'DA_THANH_TOAN', 'MB_BANK', 'MB789456', N'{"bank":"MB"}', N'Hoa don cuoi ngay');
GO

-- =====================================================
-- 7. INSERT BẢNG CHITIETHOADON (10 chi tiết hóa đơn)
-- =====================================================
INSERT INTO ChiTietHoaDon (id_hoa_don, id_game, so_luong, gia_ban, thanh_tien)
VALUES
(1, 1, 1, 1500000, 1500000),
(2, 2, 1, 1200000, 1200000),
(3, 3, 1, 500000, 500000),
(4, 5, 1, 1400000, 1400000),
(5, 6, 1, 800000, 800000),
(6, 1, 1, 1500000, 1500000),
(7, 7, 1, 900000, 900000),
(8, 8, 2, 200000, 400000),
(9, 10, 1, 1300000, 1300000),
(10, 4, 1, 1000000, 1000000);
GO

-- =====================================================
-- KIỂM TRA DỮ LIỆU ĐÃ INSERT
-- =====================================================
SELECT 'TaiKhoan: ' + CAST(COUNT(*) AS NVARCHAR) AS SoLuong FROM TaiKhoan
UNION ALL
SELECT 'KhachHang: ' + CAST(COUNT(*) AS NVARCHAR) FROM KhachHang
UNION ALL
SELECT 'DanhMuc: ' + CAST(COUNT(*) AS NVARCHAR) FROM DanhMuc
UNION ALL
SELECT 'Game: ' + CAST(COUNT(*) AS NVARCHAR) FROM Game
UNION ALL
SELECT 'KhuyenMai: ' + CAST(COUNT(*) AS NVARCHAR) FROM KhuyenMai
UNION ALL
SELECT 'HoaDon: ' + CAST(COUNT(*) AS NVARCHAR) FROM HoaDon
UNION ALL
SELECT 'ChiTietHoaDon: ' + CAST(COUNT(*) AS NVARCHAR) FROM ChiTietHoaDon;
GO

PRINT '==========================================';
PRINT 'INSERT THÀNH CÔNG DỮ LIỆU MẪU!';
PRINT '==========================================';
GO