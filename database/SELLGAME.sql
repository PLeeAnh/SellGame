-- ============================================================
--  SELLGAME DATABASE  |  Steam-style Game Store
--  Thứ tự: tạo DB → bảng nền → bảng nghiệp vụ → bảng mở rộng
-- ============================================================

CREATE DATABASE SELLGAME;
GO
USE SELLGAME;
GO

-- ============================================================
--  PHẦN 1 – BẢNG NỀN TẢNG
-- ============================================================

-- 1. TÀI KHOẢN (dùng chung cho ADMIN & CUSTOMER)
CREATE TABLE TaiKhoan (
    id            INT           PRIMARY KEY IDENTITY(1,1),
    ho_ten        NVARCHAR(100) NOT NULL,
    email         NVARCHAR(100) NOT NULL UNIQUE,
    mat_khau      NVARCHAR(100) NOT NULL,
    so_dien_thoai NVARCHAR(20),
    dia_chi       NVARCHAR(255),
    avatar        NVARCHAR(255),
    vai_tro       NVARCHAR(20)  NOT NULL,           -- ADMIN | CUSTOMER
    trang_thai    NVARCHAR(20)  NOT NULL,           -- ACTIVE | INACTIVE | BANNED
    ngay_tao      DATETIME      DEFAULT GETDATE(),
    last_login    DATETIME
);
GO

-- 2. KHÁCH HÀNG (thông tin mở rộng của TaiKhoan loại CUSTOMER)
CREATE TABLE KhachHang (
    id            INT  PRIMARY KEY IDENTITY(1,1),
    id_tai_khoan  INT  NOT NULL UNIQUE,
    ngay_sinh     DATE,
    gioi_tinh     NVARCHAR(10),                     -- Nam | Nu | Khac
    FOREIGN KEY (id_tai_khoan) REFERENCES TaiKhoan(id)
);
GO

-- 3. DANH MỤC GAME
CREATE TABLE DanhMuc (
    id            INT           PRIMARY KEY IDENTITY(1,1),
    ten_danh_muc  NVARCHAR(100) NOT NULL,
    slug          NVARCHAR(100) UNIQUE,
    mo_ta         NVARCHAR(255)
);
GO

-- ============================================================
--  PHẦN 2 – GAME & KHO KEY
-- ============================================================

-- 4. GAME
CREATE TABLE Game (
    id                  INT            PRIMARY KEY IDENTITY(1,1),
    id_danh_muc         INT            NOT NULL,

    -- Thông tin cơ bản
    ten_game            NVARCHAR(255)  NOT NULL,
    mo_ta               NVARCHAR(4000),

    -- Hình ảnh
    anh_bia             NVARCHAR(255),

    -- Phát hành
    nha_phat_hanh       NVARCHAR(255),
    ngay_phat_hanh      DATE,
    the_loai            NVARCHAR(500),

    -- Yêu cầu hệ thống
    yeu_cau_toi_thieu   NVARCHAR(1000),
    yeu_cau_de_xuat     NVARCHAR(1000),

    -- Tải về
    dung_luong          NVARCHAR(50),
    phien_ban           NVARCHAR(50),

    -- Giá (USD gốc + VNĐ quy đổi + giảm giá)
    gia_goc             DECIMAL(18,2)  NOT NULL,
    gia_vnd             DECIMAL(18,2)  NOT NULL,
    gia_giam            DECIMAL(18,2),
    phan_tram_giam      INT            DEFAULT 0,

    -- Thống kê
    luot_mua            INT            DEFAULT 0,

    -- Trạng thái
    trang_thai          NVARCHAR(50)   NOT NULL,    -- ACTIVE | INACTIVE | COMING_SOON
    ngay_tao            DATETIME       DEFAULT GETDATE(),
    ngay_cap_nhat       DATETIME,

    FOREIGN KEY (id_danh_muc) REFERENCES DanhMuc(id)
);
GO

-- 5. KEY GAME (mỗi dòng = 1 key, tránh bán trùng)
CREATE TABLE KeyGame (
    id              INT           PRIMARY KEY IDENTITY(1,1),
    id_game         INT           NOT NULL,
    ma_key          NVARCHAR(100) NOT NULL UNIQUE,
    trang_thai      NVARCHAR(20)  NOT NULL DEFAULT 'AVAILABLE', -- AVAILABLE | RESERVED | SOLD
    id_chi_tiet_hd  INT           NULL,    -- NULL = chưa bán
    ngay_ban        DATETIME      NULL,
    FOREIGN KEY (id_game)        REFERENCES Game(id),
    FOREIGN KEY (id_chi_tiet_hd) REFERENCES ChiTietHoaDon(id)  -- FK thêm sau khi tạo bảng ChiTietHoaDon
);
GO

-- ============================================================
--  PHẦN 3 – GIỎ HÀNG
-- ============================================================

-- 6. GIỎ HÀNG (mỗi khách 1 giỏ duy nhất)
CREATE TABLE GioHang (
    id              INT      PRIMARY KEY IDENTITY(1,1),
    id_khach_hang   INT      NOT NULL UNIQUE,
    ngay_tao        DATETIME DEFAULT GETDATE(),
    ngay_cap_nhat   DATETIME,
    FOREIGN KEY (id_khach_hang) REFERENCES KhachHang(id)
);
GO

-- 7. CHI TIẾT GIỎ HÀNG
CREATE TABLE GioHangChiTiet (
    id                  INT           PRIMARY KEY IDENTITY(1,1),
    id_gio_hang         INT           NOT NULL,
    id_game             INT           NOT NULL,
    gia_tai_thoi_diem   DECIMAL(18,2) NOT NULL,     -- snapshot giá lúc thêm vào giỏ
    ngay_them           DATETIME      DEFAULT GETDATE(),
    UNIQUE (id_gio_hang, id_game),                  -- không thêm trùng 1 game
    FOREIGN KEY (id_gio_hang) REFERENCES GioHang(id),
    FOREIGN KEY (id_game)     REFERENCES Game(id)
);
GO

-- ============================================================
--  PHẦN 4 – KHUYẾN MÃI & HOÁ ĐƠN
-- ============================================================

-- 8. KHUYẾN MÃI / MÃ GIẢM GIÁ
CREATE TABLE KhuyenMai (
    id              INT           PRIMARY KEY IDENTITY(1,1),
    ten_khuyen_mai  NVARCHAR(100) NOT NULL,
    ma_giam_gia     NVARCHAR(50)  UNIQUE,
    gia_tri_giam    DECIMAL(18,2) NOT NULL,
    kieu_giam       NVARCHAR(20)  NOT NULL DEFAULT 'TIEN',  -- TIEN | PHAN_TRAM
    ap_dung_cho     NVARCHAR(50),                           -- ALL_GAMES | SPECIFIC_GAMES | CATEGORY
    id_danh_muc     INT           NULL,
    so_luong        INT,
    da_dung         INT           DEFAULT 0,
    ngay_bat_dau    DATETIME      NOT NULL,
    ngay_ket_thuc   DATETIME      NOT NULL,
    trang_thai      NVARCHAR(50)  NOT NULL,                 -- ACTIVE | INACTIVE | HET_HAN
    FOREIGN KEY (id_danh_muc) REFERENCES DanhMuc(id)
);
GO

-- 9. HOÁ ĐƠN
CREATE TABLE HoaDon (
    id                      INT           PRIMARY KEY IDENTITY(1,1),
    id_khach_hang           INT           NOT NULL,
    id_khuyen_mai           INT           NULL,
    ma_hoa_don              NVARCHAR(50)  UNIQUE,
    ngay_lap                DATETIME      DEFAULT GETDATE(),
    tong_tien               DECIMAL(18,2) NOT NULL,
    tien_giam               DECIMAL(18,2) DEFAULT 0,
    thanh_tien              DECIMAL(18,2) NOT NULL,
    trang_thai              NVARCHAR(50)  NOT NULL,         -- CHO_THANH_TOAN | DA_THANH_TOAN | DA_HUY
    phuong_thuc_thanh_toan  NVARCHAR(50),                  -- VNPAY | MOMO | COD
    ma_giao_dich            NVARCHAR(100),
    thong_tin_thanh_toan    NVARCHAR(1000),
    ghi_chu                 NVARCHAR(500),
    FOREIGN KEY (id_khach_hang) REFERENCES KhachHang(id),
    FOREIGN KEY (id_khuyen_mai) REFERENCES KhuyenMai(id)
);
GO

-- 10. CHI TIẾT HOÁ ĐƠN
CREATE TABLE ChiTietHoaDon (
    id          INT           PRIMARY KEY IDENTITY(1,1),
    id_hoa_don  INT           NOT NULL,
    id_game     INT           NOT NULL,
    gia_ban     DECIMAL(18,2) NOT NULL,
    thanh_tien  DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (id_hoa_don) REFERENCES HoaDon(id),
    FOREIGN KEY (id_game)    REFERENCES Game(id)
);
GO

-- FK ngược: KeyGame → ChiTietHoaDon (thêm sau khi cả 2 bảng đã tồn tại)
ALTER TABLE KeyGame
    ADD CONSTRAINT FK_KeyGame_ChiTietHoaDon
    FOREIGN KEY (id_chi_tiet_hd) REFERENCES ChiTietHoaDon(id);
GO

-- ============================================================
--  PHẦN 5 – TÍNH NĂNG MỞ RỘNG
-- ============================================================

-- 11. ĐÁNH GIÁ GAME
CREATE TABLE DanhGia (
    id              INT           PRIMARY KEY IDENTITY(1,1),
    id_khach_hang   INT           NOT NULL,
    id_game         INT           NOT NULL,
    diem            TINYINT       NOT NULL CHECK (diem BETWEEN 1 AND 5),
    tieu_de         NVARCHAR(200),
    noi_dung        NVARCHAR(2000),
    trang_thai      NVARCHAR(20)  NOT NULL DEFAULT 'HIEN',  -- HIEN | AN
    ngay_tao        DATETIME      DEFAULT GETDATE(),
    ngay_cap_nhat   DATETIME,
    UNIQUE (id_khach_hang, id_game),                        -- mỗi khách 1 review / game
    FOREIGN KEY (id_khach_hang) REFERENCES KhachHang(id),
    FOREIGN KEY (id_game)       REFERENCES Game(id)
);
GO

-- 12. WISHLIST
CREATE TABLE WishList (
    id              INT      PRIMARY KEY IDENTITY(1,1),
    id_khach_hang   INT      NOT NULL,
    id_game         INT      NOT NULL,
    ngay_them       DATETIME DEFAULT GETDATE(),
    UNIQUE (id_khach_hang, id_game),
    FOREIGN KEY (id_khach_hang) REFERENCES KhachHang(id),
    FOREIGN KEY (id_game)       REFERENCES Game(id)
);
GO

-- ============================================================
--  INDEX – tăng tốc các truy vấn thường gặp
-- ============================================================
CREATE INDEX IX_TaiKhoan_Email         ON TaiKhoan        (email);
CREATE INDEX IX_Game_DanhMuc           ON Game            (id_danh_muc);
CREATE INDEX IX_Game_TrangThai         ON Game            (trang_thai);
CREATE INDEX IX_KeyGame_Game_Status    ON KeyGame         (id_game, trang_thai);
CREATE INDEX IX_GioHangCT_GioHang      ON GioHangChiTiet  (id_gio_hang);
CREATE INDEX IX_HoaDon_KhachHang       ON HoaDon          (id_khach_hang);
CREATE INDEX IX_HoaDon_MaHoaDon        ON HoaDon          (ma_hoa_don);
CREATE INDEX IX_KhuyenMai_Ma           ON KhuyenMai       (ma_giam_gia);
CREATE INDEX IX_DanhGia_Game           ON DanhGia         (id_game);
CREATE INDEX IX_WishList_KhachHang     ON WishList        (id_khach_hang);
GO


-- ============================================================
--  PHẦN 6 – DỮ LIỆU MẪU (10 dòng / bảng)
-- ============================================================

-- ── TaiKhoan (1 admin + 9 customer) ──────────────────────────
INSERT INTO TaiKhoan (ho_ten, email, mat_khau, so_dien_thoai, dia_chi, vai_tro, trang_thai) VALUES
(N'Nguyễn Admin',    'admin@sellgame.vn',    '123456', '0900000001', N'Hà Nội',      'ADMIN',    'ACTIVE'),
(N'Trần Văn An',     'an.tran@gmail.com',    '123456', '0900000002', N'TP.HCM',      'CUSTOMER', 'ACTIVE'),
(N'Lê Thị Bình',     'binh.le@gmail.com',    '123456', '0900000003', N'Đà Nẵng',     'CUSTOMER', 'ACTIVE'),
(N'Phạm Quốc Cường', 'cuong.pham@gmail.com', '123456', '0900000004', N'Hải Phòng',   'CUSTOMER', 'ACTIVE'),
(N'Hoàng Thị Dung',  'dung.hoang@gmail.com', '123456', '0900000005', N'Cần Thơ',     'CUSTOMER', 'ACTIVE'),
(N'Vũ Minh Đức',     'duc.vu@gmail.com',     '123456', '0900000006', N'Hà Nội',      'CUSTOMER', 'ACTIVE'),
(N'Ngô Thị Hoa',     'hoa.ngo@gmail.com',    '123456', '0900000007', N'Quảng Ninh',  'CUSTOMER', 'ACTIVE'),
(N'Đinh Văn Kiên',   'kien.dinh@gmail.com',  '123456', '0900000008', N'Huế',         'CUSTOMER', 'ACTIVE'),
(N'Bùi Thị Lan',     'lan.bui@gmail.com',    '123456', '0900000009', N'Nha Trang',   'CUSTOMER', 'ACTIVE'),
(N'Đặng Văn Mạnh',   'manh.dang@gmail.com',  '123456', '0900000010', N'Vũng Tàu',    'CUSTOMER', 'BANNED');
GO

-- ── KhachHang (9 customer, bỏ admin id=1) ────────────────────
INSERT INTO KhachHang (id_tai_khoan, ngay_sinh, gioi_tinh) VALUES
(2,  '2000-05-12', N'Nam'),
(3,  '1999-08-23', N'Nữ'),
(4,  '2001-03-07', N'Nam'),
(5,  '1998-11-15', N'Nữ'),
(6,  '2002-01-30', N'Nam'),
(7,  '2000-07-19', N'Nữ'),
(8,  '1997-09-04', N'Nam'),
(9,  '2003-12-25', N'Nữ'),
(10, '1996-06-18', N'Nam');
GO

-- ── DanhMuc ───────────────────────────────────────────────────
INSERT INTO DanhMuc (ten_danh_muc, slug, mo_ta) VALUES
(N'Hành động',      'hanh-dong',    N'Game chiến đấu tốc độ cao'),
(N'Nhập vai',       'nhap-vai',     N'Game xây dựng nhân vật, cốt truyện sâu'),
(N'Chiến thuật',    'chien-thuat',  N'Game đòi hỏi tư duy, lập kế hoạch'),
(N'Thể thao',       'the-thao',     N'Game mô phỏng thể thao thực tế'),
(N'Kinh dị',        'kinh-di',      N'Game khám phá, sinh tồn đáng sợ'),
(N'Phiêu lưu',      'phieu-luu',    N'Game khám phá thế giới rộng lớn'),
(N'Mô phỏng',       'mo-phong',     N'Game xây dựng và quản lý'),
(N'Bắn súng',       'ban-sung',     N'Game FPS và TPS'),
(N'Indie',          'indie',        N'Game từ nhà phát triển độc lập'),
(N'Nhiều người',    'nhieu-nguoi',  N'Game online nhiều người chơi');
GO

-- ── Game ──────────────────────────────────────────────────────
INSERT INTO Game (id_danh_muc, ten_game, mo_ta, nha_phat_hanh, ngay_phat_hanh, the_loai,
                  dung_luong, phien_ban, gia_goc, gia_vnd, gia_giam, phan_tram_giam,
                  trang_thai) VALUES
(1, N'Cyberpunk 2077',      N'RPG thế giới mở tương lai',       N'CD Projekt Red',  '2020-12-10', N'RPG, Hành động',   '70 GB',  '2.1',  59.99, 1499000, 29.99,  50, 'ACTIVE'),
(2, N'Elden Ring',          N'Action RPG thế giới mở khắc nghiệt', N'FromSoftware', '2022-02-25', N'RPG, Hành động',   '60 GB',  '1.10', 59.99, 1499000, NULL,    0, 'ACTIVE'),
(3, N'Civilization VI',     N'Chiến lược xây dựng đế chế',      N'Firaxis Games',   '2016-10-21', N'Chiến thuật',      '15 GB',  '1.0',  59.99,  999000, 14.99,  75, 'ACTIVE'),
(8, N'Counter-Strike 2',    N'Bắn súng tactical huyền thoại',   N'Valve',           '2023-09-27', N'Bắn súng',         '35 GB',  '1.4',   0.00,       0, NULL,    0, 'ACTIVE'),
(5, N'Resident Evil 4',     N'Kinh dị sinh tồn kinh điển',      N'Capcom',          '2023-03-24', N'Kinh dị, Hành động','67 GB', '1.1',  59.99, 1299000, 35.99,  40, 'ACTIVE'),
(6, N'The Witcher 3',       N'RPG phiêu lưu thế giới mở',       N'CD Projekt Red',  '2015-05-19', N'RPG, Phiêu lưu',   '50 GB',  '4.04', 39.99,  599000,  9.99,  75, 'ACTIVE'),
(7, N'Stardew Valley',      N'Nông trại và cuộc sống làng quê', N'ConcernedApe',    '2016-02-26', N'Mô phỏng, Indie',   '1 GB',  '1.6',  14.99,  199000, NULL,    0, 'ACTIVE'),
(4, N'FIFA 24',             N'Bóng đá thực tế nhất',            N'EA Sports',       '2023-09-29', N'Thể thao',         '50 GB',  '1.0',  69.99, 1699000, 34.99,  50, 'ACTIVE'),
(9, N'Hollow Knight',       N'Metroidvania indie đỉnh cao',     N'Team Cherry',     '2017-02-24', N'Indie, Hành động',  '9 GB',  '1.5',  14.99,  149000, NULL,    0, 'ACTIVE'),
(10,N'Among Us',            N'Game suy luận nhiều người',       N'Innersloth',      '2018-06-15', N'Indie, Nhiều người','1 GB', '2023.6', 4.99,   49000, NULL,    0, 'ACTIVE');
GO

-- ── KeyGame (10 key / game → 100 dòng, mỗi game 10 key) ──────
INSERT INTO KeyGame (id_game, ma_key, trang_thai) VALUES
-- Game 1 - Cyberpunk 2077
(1,'CP77-A1B2-C3D4-E5F6','SOLD'),
(1,'CP77-G7H8-I9J0-K1L2','SOLD'),
(1,'CP77-M3N4-O5P6-Q7R8','AVAILABLE'),
(1,'CP77-S9T0-U1V2-W3X4','AVAILABLE'),
(1,'CP77-Y5Z6-A7B8-C9D0','AVAILABLE'),
(1,'CP77-E1F2-G3H4-I5J6','AVAILABLE'),
(1,'CP77-K7L8-M9N0-O1P2','AVAILABLE'),
(1,'CP77-Q3R4-S5T6-U7V8','AVAILABLE'),
(1,'CP77-W9X0-Y1Z2-A3B4','AVAILABLE'),
(1,'CP77-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 2 - Elden Ring
(2,'ER24-A1B2-C3D4-E5F6','SOLD'),
(2,'ER24-G7H8-I9J0-K1L2','AVAILABLE'),
(2,'ER24-M3N4-O5P6-Q7R8','AVAILABLE'),
(2,'ER24-S9T0-U1V2-W3X4','AVAILABLE'),
(2,'ER24-Y5Z6-A7B8-C9D0','AVAILABLE'),
(2,'ER24-E1F2-G3H4-I5J6','AVAILABLE'),
(2,'ER24-K7L8-M9N0-O1P2','AVAILABLE'),
(2,'ER24-Q3R4-S5T6-U7V8','AVAILABLE'),
(2,'ER24-W9X0-Y1Z2-A3B4','AVAILABLE'),
(2,'ER24-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 3 - Civilization VI
(3,'CIV6-A1B2-C3D4-E5F6','SOLD'),
(3,'CIV6-G7H8-I9J0-K1L2','AVAILABLE'),
(3,'CIV6-M3N4-O5P6-Q7R8','AVAILABLE'),
(3,'CIV6-S9T0-U1V2-W3X4','AVAILABLE'),
(3,'CIV6-Y5Z6-A7B8-C9D0','AVAILABLE'),
(3,'CIV6-E1F2-G3H4-I5J6','AVAILABLE'),
(3,'CIV6-K7L8-M9N0-O1P2','AVAILABLE'),
(3,'CIV6-Q3R4-S5T6-U7V8','AVAILABLE'),
(3,'CIV6-W9X0-Y1Z2-A3B4','AVAILABLE'),
(3,'CIV6-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 5 - Resident Evil 4
(5,'RE4R-A1B2-C3D4-E5F6','SOLD'),
(5,'RE4R-G7H8-I9J0-K1L2','AVAILABLE'),
(5,'RE4R-M3N4-O5P6-Q7R8','AVAILABLE'),
(5,'RE4R-S9T0-U1V2-W3X4','AVAILABLE'),
(5,'RE4R-Y5Z6-A7B8-C9D0','AVAILABLE'),
(5,'RE4R-E1F2-G3H4-I5J6','AVAILABLE'),
(5,'RE4R-K7L8-M9N0-O1P2','AVAILABLE'),
(5,'RE4R-Q3R4-S5T6-U7V8','AVAILABLE'),
(5,'RE4R-W9X0-Y1Z2-A3B4','AVAILABLE'),
(5,'RE4R-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 6 - The Witcher 3
(6,'TW3-AA1B-C3D4-E5F6','SOLD'),
(6,'TW3-G7H8-I9J0-K1L2','AVAILABLE'),
(6,'TW3-M3N4-O5P6-Q7R8','AVAILABLE'),
(6,'TW3-S9T0-U1V2-W3X4','AVAILABLE'),
(6,'TW3-Y5Z6-A7B8-C9D0','AVAILABLE'),
(6,'TW3-E1F2-G3H4-I5J6','AVAILABLE'),
(6,'TW3-K7L8-M9N0-O1P2','AVAILABLE'),
(6,'TW3-Q3R4-S5T6-U7V8','AVAILABLE'),
(6,'TW3-W9X0-Y1Z2-A3B4','AVAILABLE'),
(6,'TW3-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 7 - Stardew Valley
(7,'SDV-AA1B-C3D4-E5F6','SOLD'),
(7,'SDV-G7H8-I9J0-K1L2','AVAILABLE'),
(7,'SDV-M3N4-O5P6-Q7R8','AVAILABLE'),
(7,'SDV-S9T0-U1V2-W3X4','AVAILABLE'),
(7,'SDV-Y5Z6-A7B8-C9D0','AVAILABLE'),
(7,'SDV-E1F2-G3H4-I5J6','AVAILABLE'),
(7,'SDV-K7L8-M9N0-O1P2','AVAILABLE'),
(7,'SDV-Q3R4-S5T6-U7V8','AVAILABLE'),
(7,'SDV-W9X0-Y1Z2-A3B4','AVAILABLE'),
(7,'SDV-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 8 - FIFA 24
(8,'FIFA-A1B2-C3D4-E5F6','SOLD'),
(8,'FIFA-G7H8-I9J0-K1L2','AVAILABLE'),
(8,'FIFA-M3N4-O5P6-Q7R8','AVAILABLE'),
(8,'FIFA-S9T0-U1V2-W3X4','AVAILABLE'),
(8,'FIFA-Y5Z6-A7B8-C9D0','AVAILABLE'),
(8,'FIFA-E1F2-G3H4-I5J6','AVAILABLE'),
(8,'FIFA-K7L8-M9N0-O1P2','AVAILABLE'),
(8,'FIFA-Q3R4-S5T6-U7V8','AVAILABLE'),
(8,'FIFA-W9X0-Y1Z2-A3B4','AVAILABLE'),
(8,'FIFA-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 9 - Hollow Knight
(9,'HK24-A1B2-C3D4-E5F6','SOLD'),
(9,'HK24-G7H8-I9J0-K1L2','AVAILABLE'),
(9,'HK24-M3N4-O5P6-Q7R8','AVAILABLE'),
(9,'HK24-S9T0-U1V2-W3X4','AVAILABLE'),
(9,'HK24-Y5Z6-A7B8-C9D0','AVAILABLE'),
(9,'HK24-E1F2-G3H4-I5J6','AVAILABLE'),
(9,'HK24-K7L8-M9N0-O1P2','AVAILABLE'),
(9,'HK24-Q3R4-S5T6-U7V8','AVAILABLE'),
(9,'HK24-W9X0-Y1Z2-A3B4','AVAILABLE'),
(9,'HK24-C5D6-E7F8-G9H0','AVAILABLE'),
-- Game 10 - Among Us
(10,'AMUS-A1B2-C3D4-E5F6','SOLD'),
(10,'AMUS-G7H8-I9J0-K1L2','AVAILABLE'),
(10,'AMUS-M3N4-O5P6-Q7R8','AVAILABLE'),
(10,'AMUS-S9T0-U1V2-W3X4','AVAILABLE'),
(10,'AMUS-Y5Z6-A7B8-C9D0','AVAILABLE'),
(10,'AMUS-E1F2-G3H4-I5J6','AVAILABLE'),
(10,'AMUS-K7L8-M9N0-O1P2','AVAILABLE'),
(10,'AMUS-Q3R4-S5T6-U7V8','AVAILABLE'),
(10,'AMUS-W9X0-Y1Z2-A3B4','AVAILABLE'),
(10,'AMUS-C5D6-E7F8-G9H0','AVAILABLE');
GO

-- ── KhuyenMai ─────────────────────────────────────────────────
INSERT INTO KhuyenMai (ten_khuyen_mai, ma_giam_gia, gia_tri_giam, kieu_giam, ap_dung_cho,
                        so_luong, ngay_bat_dau, ngay_ket_thuc, trang_thai) VALUES
(N'Sale mùa hè',        'SUMMER24',  20, 'PHAN_TRAM', 'ALL_GAMES',      100, '2025-06-01','2025-06-30','INACTIVE'),
(N'Mừng sinh nhật',     'BDAY2025',  50000, 'TIEN',   'ALL_GAMES',       50, '2025-01-01','2025-12-31','ACTIVE'),
(N'Flash Sale thứ 6',   'FLASH10',   10, 'PHAN_TRAM', 'ALL_GAMES',       30, '2025-04-18','2025-04-18','ACTIVE'),
(N'Giảm RPG',           'RPG25',     25, 'PHAN_TRAM', 'CATEGORY',       200, '2025-03-01','2025-05-31','ACTIVE'),
(N'Tân thành viên',     'NEWBIE',    30000, 'TIEN',   'ALL_GAMES',      500, '2025-01-01','2025-12-31','ACTIVE'),
(N'Indie Weekend',      'INDIE20',   20, 'PHAN_TRAM', 'CATEGORY',        80, '2025-04-12','2025-04-14','INACTIVE'),
(N'Cuối năm clearance', 'EOY2024',   50, 'PHAN_TRAM', 'ALL_GAMES',      999, '2024-12-20','2024-12-31','INACTIVE'),
(N'VIP khách hàng',     'VIP100K', 100000, 'TIEN',    'ALL_GAMES',       20, '2025-01-01','2025-12-31','ACTIVE'),
(N'Back to School',     'BTS15',     15, 'PHAN_TRAM', 'ALL_GAMES',      150, '2025-08-01','2025-09-15','INACTIVE'),
(N'Gói 3 game',         'BUNDLE3',   70000, 'TIEN',   'ALL_GAMES',       40, '2025-04-01','2025-04-30','ACTIVE');
GO

-- ── GioHang (9 khách hàng id 1-9 trong bảng KhachHang) ───────
INSERT INTO GioHang (id_khach_hang) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9);
GO

-- ── GioHangChiTiet ────────────────────────────────────────────
INSERT INTO GioHangChiTiet (id_gio_hang, id_game, gia_tai_thoi_diem) VALUES
(1, 2,  1499000),
(1, 5,  1299000),
(2, 3,   999000),
(2, 7,   199000),
(3, 1,   749000),
(3, 8,  1699000),
(4, 6,   599000),
(4, 9,   149000),
(5, 10,   49000),
(5, 4,  1499000),
(6, 2,  1499000),
(7, 5,  1299000),
(8, 7,   199000),
(9, 3,   999000),
(9, 10,   49000);
GO

-- ── HoaDon ───────────────────────────────────────────────────
INSERT INTO HoaDon (id_khach_hang, id_khuyen_mai, ma_hoa_don, tong_tien,
                    tien_giam, thanh_tien, trang_thai, phuong_thuc_thanh_toan) VALUES
(1, NULL, 'HD2025-0001', 1499000,       0, 1499000, 'DA_THANH_TOAN', 'VNPAY'),
(2, 2,    'HD2025-0002', 1499000,   50000, 1449000, 'DA_THANH_TOAN', 'MOMO'),
(3, NULL, 'HD2025-0003',  199000,       0,  199000, 'DA_THANH_TOAN', 'VNPAY'),
(4, 5,    'HD2025-0004',  599000,   30000,  569000, 'DA_THANH_TOAN', 'MOMO'),
(5, NULL, 'HD2025-0005', 2998000,       0, 2998000, 'DA_THANH_TOAN', 'VNPAY'),
(6, 3,    'HD2025-0006', 1499000,  149900, 1349100, 'DA_THANH_TOAN', 'VNPAY'),
(7, NULL, 'HD2025-0007', 1299000,       0, 1299000, 'CHO_THANH_TOAN','MOMO'),
(8, 8,    'HD2025-0008',  149000,  100000,   49000, 'DA_THANH_TOAN', 'VNPAY'),
(9, NULL, 'HD2025-0009',  999000,       0,  999000, 'DA_HUY',        'VNPAY'),
(1, 10,   'HD2025-0010', 3198000,   70000, 3128000, 'DA_THANH_TOAN', 'MOMO');
GO

-- ── ChiTietHoaDon ─────────────────────────────────────────────
INSERT INTO ChiTietHoaDon (id_hoa_don, id_game, gia_ban, thanh_tien) VALUES
(1,  2,  1499000, 1499000),
(2,  1,   749000,  749000),
(2,  6,   599000,  599000),
(3,  7,   199000,  199000),
(4,  6,   599000,  599000),
(5,  1,  1499000, 1499000),
(5,  5,  1299000, 1299000),
(6,  2,  1499000, 1499000),
(7,  5,  1299000, 1299000),
(8,  9,   149000,  149000),
(9,  3,   999000,  999000),
(10, 2,  1499000, 1499000),
(10, 6,   599000,  599000),
(10, 9,   149000,  149000);
GO

-- Gán key cho các đơn DA_THANH_TOAN
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=1,  ngay_ban=GETDATE() WHERE ma_key='ER24-A1B2-C3D4-E5F6';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=2,  ngay_ban=GETDATE() WHERE ma_key='CP77-A1B2-C3D4-E5F6';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=3,  ngay_ban=GETDATE() WHERE ma_key='TW3-AA1B-C3D4-E5F6';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=4,  ngay_ban=GETDATE() WHERE ma_key='SDV-AA1B-C3D4-E5F6';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=5,  ngay_ban=GETDATE() WHERE ma_key='TW3-G7H8-I9J0-K1L2';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=6,  ngay_ban=GETDATE() WHERE ma_key='CP77-G7H8-I9J0-K1L2';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=7,  ngay_ban=GETDATE() WHERE ma_key='RE4R-A1B2-C3D4-E5F6';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=8,  ngay_ban=GETDATE() WHERE ma_key='ER24-G7H8-I9J0-K1L2';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=10, ngay_ban=GETDATE() WHERE ma_key='HK24-A1B2-C3D4-E5F6';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=12, ngay_ban=GETDATE() WHERE ma_key='ER24-M3N4-O5P6-Q7R8';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=13, ngay_ban=GETDATE() WHERE ma_key='TW3-M3N4-O5P6-Q7R8';
UPDATE KeyGame SET trang_thai='SOLD', id_chi_tiet_hd=14, ngay_ban=GETDATE() WHERE ma_key='HK24-G7H8-I9J0-K1L2';
GO

-- Cập nhật luot_mua trên bảng Game
UPDATE Game SET luot_mua=3 WHERE id=2;
UPDATE Game SET luot_mua=2 WHERE id=1;
UPDATE Game SET luot_mua=2 WHERE id=6;
UPDATE Game SET luot_mua=2 WHERE id=9;
UPDATE Game SET luot_mua=1 WHERE id=3;
UPDATE Game SET luot_mua=1 WHERE id=5;
UPDATE Game SET luot_mua=1 WHERE id=7;
GO

-- ── DanhGia ───────────────────────────────────────────────────
INSERT INTO DanhGia (id_khach_hang, id_game, diem, tieu_de, noi_dung) VALUES
(1, 2, 5, N'Tuyệt vời!',           N'Elden Ring là game hay nhất tôi từng chơi. Thế giới rộng lớn, boss đỉnh.'),
(2, 1, 4, N'Rất đáng tiền',        N'Sau khi được vá lỗi thì Cyberpunk 2077 cực kỳ tốt. Đồ họa đẹp xuất sắc.'),
(2, 6, 5, N'Classic không lỗi thời',N'The Witcher 3 vẫn là chuẩn mực của thể loại RPG thế giới mở.'),
(3, 7, 5, N'Game힐링số 1',          N'Stardew Valley giúp mình giải stress rất hiệu quả. Cực kỳ addictive!'),
(4, 6, 4, N'Đáng chơi',            N'Cốt truyện hay, thế giới rộng. Đồ họa hơi cũ nhưng gameplay bù lại.'),
(5, 1, 3, N'Tạm được',             N'Game đẹp nhưng vẫn còn vài bug. Cốt truyện khá hay.'),
(5, 5, 5, N'Kinh điển được làm mới',N'RE4 Remake vượt xa bản gốc. Gameplay mượt, kinh dị vừa đủ.'),
(6, 2, 5, N'Hard nhưng nghiện',    N'Elden Ring khó nhưng cảm giác thắng boss rất phê. Nghiện không bỏ được!'),
(8, 9, 4, N'Indie gem',            N'Hollow Knight rất đáng tiền. Gameplay khó nhưng fair, art đẹp.'),
(9, 3, 4, N'Chiến thuật đỉnh',     N'Civ VI tốn rất nhiều giờ. Một lần nữa thôi mà đến 3 giờ sáng không hay.');
GO

-- ── WishList ──────────────────────────────────────────────────
INSERT INTO WishList (id_khach_hang, id_game) VALUES
(1, 5),(1, 8),(1, 10),
(2, 3),(2, 9),
(3, 2),(3, 5),(3, 8),
(4, 1),(4, 7),
(5, 3),(5, 8),
(6, 7),(6, 9),(6, 10),
(7, 1),(7, 3),
(8, 2),(8, 5),
(9, 4),(9, 7);
GO

SELECT * FROM TaiKhoan
SELECT * FROM KhachHang
SELECT * FROM DanhMuc
SELECT * FROM Game
SELECT * FROM KeyGame
SELECT * FROM GioHang
SELECT * FROM GioHangChiTiet
SELECT * FROM KhuyenMai
SELECT * FROM HoaDon
SELECT * FROM ChiTietHoaDon
SELECT * FROM DanhGia
SELECT * FROM WishList

DROP TABLE TaiKhoan
GO
DROP TABLE KhachHang
GO
DROP TABLE DanhMuc
GO
DROP TABLE Game
GO
DROP TABLE KeyGame
GO
DROP TABLE GioHang
GO
DROP TABLE GioHangChiTiet
GO
DROP TABLE KhuyenMai
GO
DROP TABLE HoaDon
GO
DROP TABLE ChiTietHoaDon
GO
DROP TABLE DanhGia
GO
DROP TABLE WishList
GO