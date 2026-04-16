package com.example.SellGame.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "KhachHang")
public class KhachHang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne
    @JoinColumn(name = "id_tai_khoan", referencedColumnName = "id")
    private TaiKhoan taiKhoan;

    @Column(name = "ngay_sinh")
    @Temporal(TemporalType.DATE)
    private Date ngaySinh;

    @Column(name = "gioi_tinh")
    private String gioiTinh;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    public Date getNgaySinh() {
        return ngaySinh;
    }

    public void setNgaySinh(Date ngaySinh) {
        this.ngaySinh = ngaySinh;
    }

    public String getGioiTinh() {
        return gioiTinh;
    }

    public void setGioiTinh(String gioiTinh) {
        this.gioiTinh = gioiTinh;
    }

    
}