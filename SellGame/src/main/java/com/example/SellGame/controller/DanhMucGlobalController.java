package com.example.SellGame.controller;

import com.example.SellGame.Service.DanhMucService;
import com.example.SellGame.model.DanhMuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import java.util.List;

/**
 * Inject danhMucList vào TẤT CẢ views tự động
 * Nhờ đó menu danh mục trong layout.html luôn có dữ liệu
 * Không cần thêm model.addAttribute("danhMucList") ở mỗi controller
 */
@ControllerAdvice
public class DanhMucGlobalController {

    @Autowired
    private DanhMucService danhMucService;

    @ModelAttribute("danhMucList")
    public List<DanhMuc> loadDanhMuc() {
        return danhMucService.getAll();
    }
}
