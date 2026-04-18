package com.example.SellGame.Service;

import com.example.SellGame.Repository.DanhMucRepository;
import com.example.SellGame.Repository.GameRepository;
import com.example.SellGame.model.DanhMuc;
import com.example.SellGame.model.Game;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class GameService {

    @Autowired
    private GameRepository gameRepository;

    @Autowired
    private DanhMucRepository danhMucRepository;

    /**
     * Admin: danh sách + tìm kiếm + lọc trạng thái + phân trang
     */
    public Page<Game> timKiem(String keyword, String trangThai, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("ngayTao").descending());
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        boolean hasTrangThai = trangThai != null && !trangThai.isBlank();

        if (hasKeyword && hasTrangThai) {
            return gameRepository.findByTenGameContainingIgnoreCaseAndTrangThai(keyword, trangThai, pageable);
        }
        if (hasKeyword) {
            return gameRepository.findByTenGameContainingIgnoreCase(keyword, pageable);
        }
        if (hasTrangThai) {
            return gameRepository.findByTrangThai(trangThai, pageable);
        }
        return gameRepository.findAll(pageable);
    }

    public Optional<Game> findById(Integer id) {
        return gameRepository.findById(id);
    }

    public Game save(Game game) {
        return gameRepository.save(game);
    }

    public Game update(Integer id, Game form, Integer idDanhMuc) {
        Game existing = gameRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy game id=" + id));
        DanhMuc dm = danhMucRepository.findById(idDanhMuc)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục"));

        existing.setDanhMuc(dm);
        existing.setTenGame(form.getTenGame());
        existing.setMoTa(form.getMoTa());
        existing.setAnhBia(form.getAnhBia());
        existing.setAnhScreenshots(form.getAnhScreenshots());  // 👈 THÊM DÒNG NÀY
        existing.setLinkDownload(form.getLinkDownload());      // 👈 THÊM DÒNG NÀY
        existing.setNhaPhatHanh(form.getNhaPhatHanh());
        existing.setNgayPhatHanh(form.getNgayPhatHanh());
        existing.setTheLoai(form.getTheLoai());
        existing.setYeuCauToiThieu(form.getYeuCauToiThieu());
        existing.setYeuCauDeXuat(form.getYeuCauDeXuat());
        existing.setDungLuong(form.getDungLuong());
        existing.setPhienBan(form.getPhienBan());
        existing.setGiaGoc(form.getGiaGoc());
        existing.setGiaVnd(form.getGiaVnd());
        existing.setGiaGiam(form.getGiaGiam());
        existing.setPhanTramGiam(form.getPhanTramGiam());
        existing.setTrangThai(form.getTrangThai());
        
        return gameRepository.save(existing);
    }

    /**
     * Xóa mềm: đổi trạng thái INACTIVE thay vì xóa khỏi DB
     */
    public void softDelete(Integer id) {
        Game game = gameRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy game id=" + id));
        game.setTrangThai("INACTIVE");
        gameRepository.save(game);
    }

    // ── Customer (Minh dùng) ──────────────────────────────────
    public List<Game> layGameHot() {
        return gameRepository.findTop8ByTrangThaiOrderByLuotMuaDesc("ACTIVE");
    }

    public List<Game> layGameMoi() {
        return gameRepository.findTop8ByTrangThaiOrderByNgayTaoDesc("ACTIVE");
    }
}