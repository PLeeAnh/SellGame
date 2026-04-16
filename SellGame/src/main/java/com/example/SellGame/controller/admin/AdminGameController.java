package com.example.SellGame.controller.admin;

import com.example.SellGame.model.DanhMuc;
import com.example.SellGame.model.Game;
import com.example.SellGame.service.DanhMucService;
import com.example.SellGame.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin/game")
public class AdminGameController {

    @Autowired
    private GameService gameService;

    @Autowired
    private DanhMucService danhMucService;

    // Đường dẫn lưu ảnh
    private final String UPLOAD_DIR = "src/main/resources/static/uploads/";

    // ========== LIST ==========
    @GetMapping
    public String list(Model model) {
        List<Game> danhSach = gameService.getAll();
        model.addAttribute("danhSach", danhSach);
        return "admin/game/list";
    }

    // ========== CREATE - Hiển thị form ==========
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("game", new Game());
        model.addAttribute("danhSachDanhMuc", danhMucService.getAll());
        return "admin/game/create";
    }

    // ========== CREATE - Xử lý submit ==========
    @PostMapping("/create")
    public String create(@ModelAttribute Game game,
                         @RequestParam("fileAnhBia") MultipartFile fileAnhBia,
                         RedirectAttributes ra) {
        try {
            // Xử lý upload ảnh bìa
            if (!fileAnhBia.isEmpty()) {
                String fileName = saveFile(fileAnhBia);
                game.setAnhBia("/uploads/" + fileName);
            }

            gameService.save(game);
            ra.addFlashAttribute("success", "Thêm game thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/game";
    }

    // ========== EDIT - Hiển thị form ==========
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes ra) {
        try {
            Game game = gameService.getById(id);
            model.addAttribute("game", game);
            model.addAttribute("danhSachDanhMuc", danhMucService.getAll());
            return "admin/game/edit";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Không tìm thấy game!");
            return "redirect:/admin/game";
        }
    }

    // ========== EDIT - Xử lý submit ==========
    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id,
                         @ModelAttribute Game game,
                         @RequestParam("fileAnhBia") MultipartFile fileAnhBia,
                         RedirectAttributes ra) {
        try {
            game.setId(id);

            // Nếu có upload ảnh mới thì cập nhật
            if (!fileAnhBia.isEmpty()) {
                String fileName = saveFile(fileAnhBia);
                game.setAnhBia("/uploads/" + fileName);
            } else {
                // Giữ ảnh cũ
                Game oldGame = gameService.getById(id);
                game.setAnhBia(oldGame.getAnhBia());
            }

            gameService.save(game);
            ra.addFlashAttribute("success", "Cập nhật game thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/game";
    }

    // ========== DELETE ==========
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes ra) {
        try {
            gameService.delete(id);
            ra.addFlashAttribute("success", "Xóa game thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Không thể xóa game này!");
        }
        return "redirect:/admin/game";
    }

    // ========== Helper: Lưu file ảnh ==========
    private String saveFile(MultipartFile file) throws IOException {
        // Tạo thư mục nếu chưa có
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Tạo tên file duy nhất
        String originalName = file.getOriginalFilename();
        String extension = originalName.substring(originalName.lastIndexOf("."));
        String fileName = UUID.randomUUID().toString() + extension;

        // Lưu file
        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath);

        return fileName;
    }
}