package com.example.SellGame.controller.admin;

import com.example.SellGame.Service.DanhMucService;
import com.example.SellGame.model.DanhMuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/danhmuc")
public class AdminDanhMucController {

    @Autowired
    private DanhMucService danhMucService;

    // LIST
    @GetMapping
    public String list(Model model) {
        model.addAttribute("danhMucList", danhMucService.getAll());
        model.addAttribute("pageTitle", "Quản lý danh mục");
        model.addAttribute("content", "admin/danhmuc/list");  // 👈 THÊM DÒNG NÀY
        return "admin/layout";  // 👈 SỬA THÀNH admin/layout
    }

    // FORM THÊM
    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("danhMuc", new DanhMuc());
        model.addAttribute("pageTitle", "Thêm danh mục");
        model.addAttribute("content", "admin/danhmuc/create");  // 👈 THÊM DÒNG NÀY
        return "admin/layout";  // 👈 SỬA THÀNH admin/layout
    }

    // XỬ LÝ THÊM
    @PostMapping("/create")
    public String create(@ModelAttribute DanhMuc danhMuc,
            RedirectAttributes ra) {
        if (danhMuc.getTenDanhMuc() == null || danhMuc.getTenDanhMuc().isBlank()) {
            ra.addFlashAttribute("error", "Tên danh mục không được để trống!");
            return "redirect:/admin/danhmuc/create";
        }
        if (danhMucService.existsByTen(danhMuc.getTenDanhMuc())) {
            ra.addFlashAttribute("error", "Tên danh mục đã tồn tại!");
            return "redirect:/admin/danhmuc/create";
        }
        danhMucService.save(danhMuc);
        ra.addFlashAttribute("success", "Thêm danh mục thành công!");
        return "redirect:/admin/danhmuc";
    }

    // FORM SỬA
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model,
            RedirectAttributes ra) {
        return danhMucService.findById(id).map(dm -> {
            model.addAttribute("danhMuc", dm);
            model.addAttribute("pageTitle", "Sửa danh mục");
            model.addAttribute("content", "admin/danhmuc/edit");  // 👈 THÊM DÒNG NÀY
            return "admin/layout";  // 👈 SỬA THÀNH admin/layout
        }).orElseGet(() -> {
            ra.addFlashAttribute("error", "Không tìm thấy danh mục!");
            return "redirect:/admin/danhmuc";
        });
    }

    // XỬ LÝ SỬA
    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Integer id,
            @ModelAttribute DanhMuc form,
            RedirectAttributes ra) {
        try {
            danhMucService.update(id, form);
            ra.addFlashAttribute("success", "Cập nhật danh mục thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/danhmuc";
    }

    // XÓA
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes ra) {
        try {
            danhMucService.delete(id);
            ra.addFlashAttribute("success", "Xóa danh mục thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/danhmuc";
    }
}
