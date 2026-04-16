package com.example.SellGame.controller.TaiKhoan;

import com.example.SellGame.Service.TaiKhoanService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class TaiKhoanController {

    @Autowired
    private TaiKhoanService taiKhoanService;

    @GetMapping("/")
    public String trangChu(Model model) {
        model.addAttribute("content", "TaiKhoan/index :: content");
        return "layout/layout"; 
    }

    @GetMapping("/dang-ky")
    public String showFormDangKy(Model model) {
        model.addAttribute("taiKhoan", new TaiKhoan());
        model.addAttribute("content", "TaiKhoan/dang-ky :: content");
        return "layout/layout";
    }

    @PostMapping("/dang-ky")
    public String processDangKy(@ModelAttribute TaiKhoan taiKhoan, Model model) {
        if (taiKhoanService.checkEmailExist(taiKhoan.getEmail())) {
            model.addAttribute("error", "Email này đã được sử dụng!");
            model.addAttribute("content", "TaiKhoan/dang-ky :: content");
            return "layout/layout";
        }
        taiKhoanService.dangKy(taiKhoan);
        model.addAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
        model.addAttribute("content", "TaiKhoan/dang-nhap :: content");
        return "layout/layout";
    }

    @GetMapping("/dang-nhap")
    public String showFormDangNhap(Model model) {
        model.addAttribute("content", "TaiKhoan/dang-nhap :: content");
        return "layout/layout";
    }

    @PostMapping("/dang-nhap")
    public String processDangNhap(@RequestParam String email, 
                                  @RequestParam String matKhau, 
                                  HttpSession session, 
                                  Model model) {
        TaiKhoan tk = taiKhoanService.dangNhap(email, matKhau);
        if (tk != null) {
            // Đăng nhập thành công -> Lưu vào session
            session.setAttribute("userLogged", tk);
            
            // KIỂM TRA VAI TRÒ ĐỂ CHUYỂN HƯỚNG
            if ("ADMIN".equals(tk.getVaiTro())) {
                // Nếu là ADMIN -> Chuyển vào trang Quản trị (Dashboard)
                return "redirect:/admin/dashboard"; 
            } else {
                // Nếu là CUSTOMER -> Trả về trang chủ (như cũ)
                model.addAttribute("content", "TaiKhoan/index :: content");
                return "layout/layout";
            }
            
        } else {
            // Đăng nhập thất bại
            model.addAttribute("error", "Email hoặc mật khẩu không chính xác, hoặc tài khoản bị khóa!");
            model.addAttribute("content", "TaiKhoan/dang-nhap :: content");
            return "layout/layout";
        }
    }
    // --- TRANG QUẢN TRỊ CỦA ADMIN ---
    @GetMapping("/admin/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        // Kiểm tra xem đã đăng nhập chưa và có phải ADMIN không
        TaiKhoan tkSession = (TaiKhoan) session.getAttribute("userLogged");
        if (tkSession == null || !"ADMIN".equals(tkSession.getVaiTro())) {
            // Nếu chưa đăng nhập hoặc không phải Admin thì đuổi về trang đăng nhập
            return "redirect:/dang-nhap";
        }
        
        // Gọi file giao diện dashboard.html trong thư mục templates/admin/
        model.addAttribute("content", "admin/dashboard :: content");
        return "layout/layout";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("userLogged");
        return "redirect:/"; 
    }

    @GetMapping("/ho-so-ca-nhan")
    public String showHoSo(HttpSession session, Model model) {
        TaiKhoan tkSession = (TaiKhoan) session.getAttribute("userLogged");
        if (tkSession == null) {
            return "redirect:/dang-nhap";
        }
        TaiKhoan tkDB = taiKhoanService.findById(tkSession.getId());
        model.addAttribute("user", tkDB);
        model.addAttribute("content", "TaiKhoan/ho-so-ca-nhan :: content");
        return "layout/layout";
    }
}