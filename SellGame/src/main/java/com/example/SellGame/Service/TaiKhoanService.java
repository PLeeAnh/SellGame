//package com.example.SellGame.Service;
//
//import com.example.SellGame.Repository.TaiKhoanRepository;
//import com.example.SellGame.model.KhachHang;
//import com.example.SellGame.Repository.KhachHangRepository;
//import com.example.SellGame.model.TaiKhoan;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import java.util.Date;
//import java.util.Optional;
//
//@Service
//public class TaiKhoanService {
//
//    @Autowired
//    private TaiKhoanRepository taiKhoanRepository;
//
//    @Autowired
//    private KhachHangRepository khachHangRepository;
//
//    public boolean checkEmailExist(String email) {
//        return taiKhoanRepository.existsByEmail(email);
//    }
//
//    public TaiKhoan dangKy(TaiKhoan taiKhoan) {
//        taiKhoan.setNgayTao(new Date());
//        taiKhoan.setVaiTro("CUSTOMER");
//        taiKhoan.setTrangThai("ACTIVE");
//        TaiKhoan savedTaiKhoan = taiKhoanRepository.save(taiKhoan);
//
//        KhachHang khachHang = new KhachHang();
//        khachHang.setTaiKhoan(savedTaiKhoan);
//        khachHangRepository.save(khachHang);
//
//        return savedTaiKhoan;
//    }
//
//    public TaiKhoan dangNhap(String email, String matKhau) {
//        Optional<TaiKhoan> tkOpt = taiKhoanRepository.findByEmail(email);
//        if (tkOpt.isPresent()) {
//            TaiKhoan tk = tkOpt.get();
//            if (tk.getMatKhau().equals(matKhau) && tk.getTrangThai().equals("ACTIVE")) {
//                tk.setLastLogin(new Date());
//                taiKhoanRepository.save(tk);
//                return tk;
//            }
//        }
//        return null;
//    }
//
//    public TaiKhoan findById(Integer id) {
//        return taiKhoanRepository.findById(id).orElse(null);
//    }
//}