package com.example.SellGame.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "DanhMuc")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DanhMuc {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "ten_danh_muc", nullable = false, length = 100)
    private String tenDanhMuc;

    @Column(name = "slug", unique = true, length = 100)
    private String slug;

    @Column(name = "mo_ta", length = 255)
    private String moTa;
    
    
}
