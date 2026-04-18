package com.example.SellGame.model;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Game")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Game {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_danh_muc", nullable = false)
    private DanhMuc danhMuc;

    @Column(name = "ten_game", nullable = false, length = 255)
    private String tenGame;

    @Column(name = "mo_ta", length = 4000)
    private String moTa;

    @Column(name = "anh_bia", length = 255)
    private String anhBia;

    // Lưu JSON array URLs screenshots: ["url1","url2",...]
    @Column(name = "anh_screenshots", columnDefinition = "NVARCHAR(MAX)")
    private String anhScreenshots;

    @Column(name = "link_download", length = 500)
    private String linkDownload;

    @Column(name = "nha_phat_hanh", length = 255)
    private String nhaPhatHanh;

    @Column(name = "ngay_phat_hanh")
    private LocalDate ngayPhatHanh;

    @Column(name = "the_loai", length = 500)
    private String theLoai;

    @Column(name = "yeu_cau_toi_thieu", length = 1000)
    private String yeuCauToiThieu;

    @Column(name = "yeu_cau_de_xuat", length = 1000)
    private String yeuCauDeXuat;

    @Column(name = "dung_luong", length = 50)
    private String dungLuong;

    @Column(name = "phien_ban", length = 50)
    private String phienBan;

    @Column(name = "gia_goc", nullable = false, precision = 18, scale = 2)
    private BigDecimal giaGoc;

    @Column(name = "gia_vnd", nullable = false, precision = 18, scale = 2)
    private BigDecimal giaVnd;

    @Column(name = "gia_giam", precision = 18, scale = 2)
    private BigDecimal giaGiam;

    @Column(name = "phan_tram_giam")
    private Integer phanTramGiam = 0;

    @Column(name = "luot_mua")
    private Integer luotMua = 0;

    @Column(name = "trang_thai", nullable = false, length = 50)
    private String trangThai;

    @Column(name = "ngay_tao")
    private LocalDateTime ngayTao;

    @Column(name = "ngay_cap_nhat")
    private LocalDateTime ngayCapNhat;

    @PrePersist
    public void prePersist() {
        this.ngayTao = LocalDateTime.now();
        if (this.phanTramGiam == null) {
            this.phanTramGiam = 0;
        }
        if (this.luotMua == null) {
            this.luotMua = 0;
        }
        // FIX: set trangThai mặc định khi tạo mới
        if (this.trangThai == null || this.trangThai.isBlank()) {
            this.trangThai = "ACTIVE";
        }
    }

    @PreUpdate
    public void preUpdate() {
        this.ngayCapNhat = LocalDateTime.now();
    }

    // Giá hiển thị: ưu tiên gia_giam nếu > 0
    public BigDecimal getGiaHienThi() {
        return (giaGiam != null && giaGiam.compareTo(BigDecimal.ZERO) > 0) ? giaGiam : giaVnd;
    }

    public boolean isDangSale() {
        return phanTramGiam != null && phanTramGiam > 0;
    }
}
