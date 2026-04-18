package com.example.SellGame.controller.admin;

import com.example.SellGame.Service.DanhMucService;
import com.example.SellGame.Service.FileUploadService;
import com.example.SellGame.Service.GameService;
import com.example.SellGame.model.DanhMuc;
import com.example.SellGame.model.Game;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin/game")
public class AdminGameController {

    @Autowired
    private GameService gameService;

    @Autowired
    private DanhMucService danhMucService;

    @Autowired
    private FileUploadService fileUploadService;

    // ── LIST ─────────────────────────────────────────────────
    @GetMapping
    public String list(@RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "") String trangThai,
            @RequestParam(defaultValue = "0") int page,
            Model model) {
        Page<Game> gamePage = gameService.timKiem(keyword, trangThai, page, 10);
        model.addAttribute("gamePage", gamePage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("trangThai", trangThai);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", gamePage.getTotalPages());
        model.addAttribute("pageTitle", "Quản lý game");
        model.addAttribute("content", "admin/game/list");
        return "admin/layout";
    }

    // ── FORM THÊM ─────────────────────────────────────────────
    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("game", new Game());
        model.addAttribute("danhMucList", danhMucService.getAll());
        model.addAttribute("pageTitle", "Thêm game mới");
        model.addAttribute("content", "admin/game/create");  // 👈 QUAN TRỌNG
        return "admin/layout";
    }

    // ── XỬ LÝ THÊM ───────────────────────────────────────────
    @PostMapping("/create")
    public String create(@ModelAttribute Game game,
            @RequestParam Integer idDanhMuc,
            @RequestParam(value = "anhBiaFile", required = false) MultipartFile anhBiaFile,
            @RequestParam(value = "anhScreenshotsFiles", required = false) MultipartFile[] anhScreenshotsFiles,
            @RequestParam(value = "linkDownload", required = false) String linkDownload,
            RedirectAttributes ra) {
        try {
            DanhMuc dm = danhMucService.findById(idDanhMuc)
                    .orElseThrow(() -> new RuntimeException("Danh mục không hợp lệ"));
            game.setDanhMuc(dm);

            if (anhBiaFile != null && !anhBiaFile.isEmpty()) {
                String anhUrl = fileUploadService.uploadAnh(anhBiaFile);
                game.setAnhBia(anhUrl);
            }

            if (anhScreenshotsFiles != null && anhScreenshotsFiles.length > 0) {
                List<String> screenshotUrls = new ArrayList<>();
                for (MultipartFile file : anhScreenshotsFiles) {
                    if (!file.isEmpty()) {
                        String url = fileUploadService.uploadAnh(file);
                        screenshotUrls.add(url);
                    }
                }
                ObjectMapper mapper = new ObjectMapper();
                game.setAnhScreenshots(mapper.writeValueAsString(screenshotUrls));
            }

            game.setLinkDownload(linkDownload);

            if (game.getTrangThai() == null || game.getTrangThai().isBlank()) {
                game.setTrangThai("ACTIVE");
            }

            gameService.save(game);
            ra.addFlashAttribute("success", "Thêm game \"" + game.getTenGame() + "\" thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/admin/game/create";
        }
        return "redirect:/admin/game";
    }

    // ── FORM SỬA ─────────────────────────────────────────────
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model, RedirectAttributes ra) {
        return gameService.findById(id).map(game -> {
            model.addAttribute("game", game);
            model.addAttribute("danhMucList", danhMucService.getAll());
            model.addAttribute("pageTitle", "Sửa game: " + game.getTenGame());
            model.addAttribute("content", "admin/game/edit");  // 👈 QUAN TRỌNG
            return "admin/layout";
        }).orElseGet(() -> {
            ra.addFlashAttribute("error", "Không tìm thấy game!");
            return "redirect:/admin/game";
        });
    }

    // ── XỬ LÝ SỬA ────────────────────────────────────────────
    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Integer id,
            @ModelAttribute Game form,
            @RequestParam Integer idDanhMuc,
            @RequestParam(value = "anhBiaFile", required = false) MultipartFile anhBiaFile,
            @RequestParam(value = "anhScreenshotsFiles", required = false) MultipartFile[] anhScreenshotsFiles,
            @RequestParam(value = "linkDownload", required = false) String linkDownload,
            RedirectAttributes ra) {
        try {
            Game existingGame = gameService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy game"));

            if (anhBiaFile != null && !anhBiaFile.isEmpty()) {
                if (existingGame.getAnhBia() != null) {
                    fileUploadService.xoaAnh(existingGame.getAnhBia());
                }
                String anhUrl = fileUploadService.uploadAnh(anhBiaFile);
                existingGame.setAnhBia(anhUrl);
            }

            if (anhScreenshotsFiles != null && anhScreenshotsFiles.length > 0) {
                List<String> screenshotUrls = new ArrayList<>();
                if (existingGame.getAnhScreenshots() != null && !existingGame.getAnhScreenshots().isEmpty()) {
                    try {
                        ObjectMapper mapper = new ObjectMapper();
                        List<String> oldUrls = mapper.readValue(existingGame.getAnhScreenshots(), List.class);
                        screenshotUrls.addAll(oldUrls);
                    } catch (Exception e) {
                    }
                }
                for (MultipartFile file : anhScreenshotsFiles) {
                    if (!file.isEmpty()) {
                        String url = fileUploadService.uploadAnh(file);
                        screenshotUrls.add(url);
                    }
                }
                ObjectMapper mapper = new ObjectMapper();
                existingGame.setAnhScreenshots(mapper.writeValueAsString(screenshotUrls));
            }

            existingGame.setLinkDownload(linkDownload);

            DanhMuc dm = danhMucService.findById(idDanhMuc)
                    .orElseThrow(() -> new RuntimeException("Danh mục không hợp lệ"));
            existingGame.setDanhMuc(dm);

            existingGame.setTenGame(form.getTenGame());
            existingGame.setMoTa(form.getMoTa());
            existingGame.setNhaPhatHanh(form.getNhaPhatHanh());
            existingGame.setNgayPhatHanh(form.getNgayPhatHanh());
            existingGame.setTheLoai(form.getTheLoai());
            existingGame.setYeuCauToiThieu(form.getYeuCauToiThieu());
            existingGame.setYeuCauDeXuat(form.getYeuCauDeXuat());
            existingGame.setDungLuong(form.getDungLuong());
            existingGame.setPhienBan(form.getPhienBan());
            existingGame.setGiaGoc(form.getGiaGoc());
            existingGame.setGiaVnd(form.getGiaVnd());
            existingGame.setGiaGiam(form.getGiaGiam());
            existingGame.setPhanTramGiam(form.getPhanTramGiam());
            existingGame.setTrangThai(form.getTrangThai());

            gameService.save(existingGame);
            ra.addFlashAttribute("success", "Cập nhật game thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/game";
    }

    // ── XÓA MỀM ──────────────────────────────────────────────
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes ra) {
        try {
            gameService.softDelete(id);
            ra.addFlashAttribute("success", "Đã ẩn game thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/game";
    }

    // ── KÍCH HOẠT LẠI ────────────────────────────────────────
    @GetMapping("/restore/{id}")
    public String restore(@PathVariable Integer id, RedirectAttributes ra) {
        try {
            Game game = gameService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy game"));
            game.setTrangThai("ACTIVE");
            gameService.save(game);
            ra.addFlashAttribute("success", "Đã kích hoạt lại game!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/game";
    }
}
