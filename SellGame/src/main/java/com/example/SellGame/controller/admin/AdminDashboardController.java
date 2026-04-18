package com.example.SellGame.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("soDanhMuc", 5);
        model.addAttribute("soGame", 12);
        model.addAttribute("soHoaDon", 8);
        model.addAttribute("doanhThu", "15.500.000đ");
        model.addAttribute("content", "admin/dashboard");
        return "admin/layout";
    }
    
    @GetMapping("/ho-so")
    public String hoSo(Model model) {
        model.addAttribute("content", "TaiKhoan/ho-so-ca-nhan");
        return "admin/layout";
    }
    
    @GetMapping("/doi-mat-khau")
    public String doiMatKhau(Model model) {
        model.addAttribute("content", "TaiKhoan/doi-mat-khau");
        return "admin/layout";
    }
}