package com.example.SellGame.Service;

import com.example.SellGame.Repository.DanhMucRepository;
import com.example.SellGame.Repository.GameRepository;
import com.example.SellGame.model.DanhMuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.text.Normalizer;
import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;

@Service
public class DanhMucService {

    @Autowired
    private DanhMucRepository danhMucRepository;

    @Autowired
    private GameRepository gameRepository;

    public List<DanhMuc> getAll() {
        return danhMucRepository.findAll();
    }

    public Optional<DanhMuc> findById(Integer id) {
        return danhMucRepository.findById(id);
    }

    public Optional<DanhMuc> findBySlug(String slug) {
        return danhMucRepository.findBySlug(slug);
    }

    public DanhMuc save(DanhMuc danhMuc) {
        if (danhMuc.getSlug() == null || danhMuc.getSlug().isBlank()) {
            danhMuc.setSlug(taoSlug(danhMuc.getTenDanhMuc()));
        }
        return danhMucRepository.save(danhMuc);
    }

    public DanhMuc update(Integer id, DanhMuc form) {
        DanhMuc existing = danhMucRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục id=" + id));
        existing.setTenDanhMuc(form.getTenDanhMuc());
        existing.setMoTa(form.getMoTa());
        if (form.getSlug() != null && !form.getSlug().isBlank()) {
            existing.setSlug(form.getSlug());
        } else {
            existing.setSlug(taoSlug(form.getTenDanhMuc()));
        }
        return danhMucRepository.save(existing);
    }

    public void delete(Integer id) {
        long soGame = gameRepository.countByDanhMucId(id);
        if (soGame > 0) {
            throw new RuntimeException(
                    "Không thể xóa! Danh mục này đang chứa " + soGame + " game.");
        }
        danhMucRepository.deleteById(id);
    }

    public boolean existsByTen(String ten) {
        return danhMucRepository.existsByTenDanhMuc(ten);
    }

    public static String taoSlug(String input) {
        if (input == null) {
            return "";
        }
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        String noAccent = Pattern.compile("\\p{InCombiningDiacriticalMarks}+")
                .matcher(normalized).replaceAll("");
        return noAccent.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");
    }
}