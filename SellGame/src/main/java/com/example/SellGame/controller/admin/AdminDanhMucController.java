package com.example.SellGame.controller.admin;

import com.example.SellGame.model.DanhMuc;
import com.example.SellGame.service.DanhMucService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/danh-muc")
public class AdminDanhMucController {

    @Autowired
    private DanhMucService danhMucService;

    // ========== LIST ==========
    @GetMapping
    public String list(Model model) {
        List<DanhMuc> danhSach = danhMucService.getAll();
        model.addAttribute("danhSach", danhSach);
        return "admin/danhmuc/list";
    }

    // ========== CREATE - Hiển thị form ==========
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("danhMuc", new DanhMuc());
        return "admin/danhmuc/create";
    }

    // ========== CREATE - Xử lý submit ==========
    @PostMapping("/create")
    public String create(@ModelAttribute DanhMuc danhMuc, RedirectAttributes ra) {
        try {
            danhMucService.save(danhMuc);
            ra.addFlashAttribute("success", "Thêm danh mục thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/danh-muc";
    }

    // ========== EDIT - Hiển thị form ==========
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes ra) {
        try {
            DanhMuc danhMuc = danhMucService.getById(id);
            model.addAttribute("danhMuc", danhMuc);
            return "admin/danhmuc/edit";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Không tìm thấy danh mục!");
            return "redirect:/admin/danh-muc";
        }
    }

    // ========== EDIT - Xử lý submit ==========
    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @ModelAttribute DanhMuc danhMuc, RedirectAttributes ra) {
        try {
            danhMuc.setId(id);
            danhMucService.save(danhMuc);
            ra.addFlashAttribute("success", "Cập nhật danh mục thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/danh-muc";
    }

    // ========== DELETE ==========
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes ra) {
        try {
            danhMucService.delete(id);
            ra.addFlashAttribute("success", "Xóa danh mục thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Không thể xóa danh mục này (có thể đang có game)!");
        }
        return "redirect:/admin/danh-muc";
    }
}