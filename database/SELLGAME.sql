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
  mo_ta NVARCHAR(255)  -- Đã xóa dấu phẩy thừa
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
  phuong_thuc_thanh_toan NVARCHAR(50),        -- VNPAY, MOMO, ATM
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