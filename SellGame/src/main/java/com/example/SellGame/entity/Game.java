/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.SellGame.entity;

<<<<<<< Updated upstream
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.*;
import java.util.Date;

=======
>>>>>>> Stashed changes
/**
 *
 * @author Administrator
 */
<<<<<<< Updated upstream
@Entity
@Table(name = "Game")
public class Game {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // 🔗 Khóa ngoại
    @ManyToOne
    @JoinColumn(name = "id_danh_muc")
    private DanhMuc danhMuc;

    // 📝 Thông tin cơ bản
    @Column(name = "ten_game")
    private String tenGame;

    // 🖼 Hình ảnh
    @Column(name = "anh_bia")
    private String anhBia;

    @Column(name = "anh_screenshots", columnDefinition = "NVARCHAR(4000)")
    private String anhScreenshots;

    // 🏢 Phát hành
    @Column(name = "nha_phat_hanh")
    private String nhaPhatHanh;

    @Temporal(TemporalType.DATE)
    @Column(name = "ngay_phat_hanh")
    private Date ngayPhatHanh;

    // 🎯 Phân loại
    @Column(name = "the_loai")
    private String theLoai;

    // 💻 Yêu cầu hệ thống
    @Column(name = "yeu_cau_toi_thieu", length = 1000)
    private String yeuCauToiThieu;

    @Column(name = "yeu_cau_de_xuat", length = 1000)
    private String yeuCauDeXuat;

    // 🔗 Download
    @Column(name = "link_download")
    private String linkDownload;

    @Column(name = "dung_luong")
    private String dungLuong;

    @Column(name = "phien_ban")
    private String phienBan;

    // 💰 Giá
    @Column(name = "gia_goc")
    private Double giaGoc;

    @Column(name = "gia_vnd")
    private Double giaVnd;

    @Column(name = "gia_giam")
    private Double giaGiam;

    @Column(name = "phan_tram_giam")
    private Integer phanTramGiam;

    // 📊 Thống kê
    @Column(name = "luot_mua")
    private Integer luotMua;

    // 🔄 Trạng thái
    @Column(name = "trang_thai")
    private String trangThai;

    // 🕒 Thời gian
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngay_tao")
    private Date ngayTao;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngay_cap_nhat")
    private Date ngayCapNhat;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public DanhMuc getDanhMuc() {
        return danhMuc;
    }

    public void setDanhMuc(DanhMuc danhMuc) {
        this.danhMuc = danhMuc;
    }

    public String getTenGame() {
        return tenGame;
    }

    public void setTenGame(String tenGame) {
        this.tenGame = tenGame;
    }

    public String getAnhBia() {
        return anhBia;
    }

    public void setAnhBia(String anhBia) {
        this.anhBia = anhBia;
    }

    public String getAnhScreenshots() {
        return anhScreenshots;
    }

    public void setAnhScreenshots(String anhScreenshots) {
        this.anhScreenshots = anhScreenshots;
    }

    public String getNhaPhatHanh() {
        return nhaPhatHanh;
    }

    public void setNhaPhatHanh(String nhaPhatHanh) {
        this.nhaPhatHanh = nhaPhatHanh;
    }

    public Date getNgayPhatHanh() {
        return ngayPhatHanh;
    }

    public void setNgayPhatHanh(Date ngayPhatHanh) {
        this.ngayPhatHanh = ngayPhatHanh;
    }

    public String getTheLoai() {
        return theLoai;
    }

    public void setTheLoai(String theLoai) {
        this.theLoai = theLoai;
    }

    public String getYeuCauToiThieu() {
        return yeuCauToiThieu;
    }

    public void setYeuCauToiThieu(String yeuCauToiThieu) {
        this.yeuCauToiThieu = yeuCauToiThieu;
    }

    public String getYeuCauDeXuat() {
        return yeuCauDeXuat;
    }

    public void setYeuCauDeXuat(String yeuCauDeXuat) {
        this.yeuCauDeXuat = yeuCauDeXuat;
    }

    public String getLinkDownload() {
        return linkDownload;
    }

    public void setLinkDownload(String linkDownload) {
        this.linkDownload = linkDownload;
    }

    public String getDungLuong() {
        return dungLuong;
    }

    public void setDungLuong(String dungLuong) {
        this.dungLuong = dungLuong;
    }

    public String getPhienBan() {
        return phienBan;
    }

    public void setPhienBan(String phienBan) {
        this.phienBan = phienBan;
    }

    public Double getGiaGoc() {
        return giaGoc;
    }

    public void setGiaGoc(Double giaGoc) {
        this.giaGoc = giaGoc;
    }

    public Double getGiaVnd() {
        return giaVnd;
    }

    public void setGiaVnd(Double giaVnd) {
        this.giaVnd = giaVnd;
    }

    public Double getGiaGiam() {
        return giaGiam;
    }

    public void setGiaGiam(Double giaGiam) {
        this.giaGiam = giaGiam;
    }

    public Integer getPhanTramGiam() {
        return phanTramGiam;
    }

    public void setPhanTramGiam(Integer phanTramGiam) {
        this.phanTramGiam = phanTramGiam;
    }

    public Integer getLuotMua() {
        return luotMua;
    }

    public void setLuotMua(Integer luotMua) {
        this.luotMua = luotMua;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public Date getNgayCapNhat() {
        return ngayCapNhat;
    }

    public void setNgayCapNhat(Date ngayCapNhat) {
        this.ngayCapNhat = ngayCapNhat;
    }
    
=======
public class Game {
>>>>>>> Stashed changes
    
}
