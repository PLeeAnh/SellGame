package com.example.SellGame.Service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.*;
import java.util.UUID;

/**
 * Xử lý upload ảnh game lên thư mục uploads/games/
 * Ảnh được lưu tại: [project_root]/uploads/games/[filename]
 * Truy cập qua URL: /uploads/games/[filename]
 */
@Service
public class FileUploadService {

    // Thư mục lưu ảnh (tương đối với thư mục chạy project)
    private static final String UPLOAD_DIR = "uploads/games/";

    /**
     * Upload ảnh, trả về đường dẫn để lưu vào DB
     * Ví dụ trả về: /uploads/games/abc123.jpg
     */
    public String uploadAnh(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // Lấy đuôi file (.jpg, .png, .webp...)
        String originalName = file.getOriginalFilename();
        String extension = "";
        if (originalName != null && originalName.contains(".")) {
            extension = originalName.substring(originalName.lastIndexOf(".")).toLowerCase();
        }

        // Chỉ cho phép ảnh
        if (!extension.matches("\\.(jpg|jpeg|png|gif|webp)")) {
            throw new IllegalArgumentException("Chỉ cho phép file ảnh: jpg, png, gif, webp");
        }

        // Tạo tên file ngẫu nhiên để tránh trùng
        String newFileName = UUID.randomUUID().toString() + extension;

        // Tạo thư mục nếu chưa có
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Lưu file
        Path filePath = uploadPath.resolve(newFileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        // Trả về URL để lưu vào DB
        return "/uploads/games/" + newFileName;
    }

    /**
     * Xóa ảnh cũ khi cập nhật game
     */
    public void xoaAnh(String anhUrl) {
        if (anhUrl == null || anhUrl.isBlank()) return;
        try {
            // Bỏ dấu / ở đầu để lấy đường dẫn thực
            String filePath = anhUrl.startsWith("/") ? anhUrl.substring(1) : anhUrl;
            Path path = Paths.get(filePath);
            Files.deleteIfExists(path);
        } catch (IOException e) {
            // Không cần throw, chỉ log
            System.err.println("Không xóa được ảnh: " + anhUrl);
        }
    }
}
