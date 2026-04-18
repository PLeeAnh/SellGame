package com.example.SellGame.Repository;

import com.example.SellGame.model.DanhMuc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface DanhMucRepository extends JpaRepository<DanhMuc, Integer> {

    Optional<DanhMuc> findBySlug(String slug);

    boolean existsBySlug(String slug);

    boolean existsByTenDanhMuc(String tenDanhMuc);
}