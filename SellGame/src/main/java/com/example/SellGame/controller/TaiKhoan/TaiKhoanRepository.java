package com.example.SellGame.controller.TaiKhoan;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface TaiKhoanRepository extends JpaRepository<TaiKhoan, Integer> {
    Optional<TaiKhoan> findByEmail(String email);
    boolean existsByEmail(String email);
}