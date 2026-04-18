package com.example.SellGame.Repository;

import com.example.SellGame.model.Game;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface GameRepository extends JpaRepository<Game, Integer> {

    Page<Game> findAll(Pageable pageable);

    Page<Game> findByTenGameContainingIgnoreCase(String tenGame, Pageable pageable);

    Page<Game> findByDanhMucId(Integer idDanhMuc, Pageable pageable);

    Page<Game> findByTrangThai(String trangThai, Pageable pageable);

    Page<Game> findByTenGameContainingIgnoreCaseAndTrangThai(
            String tenGame, String trangThai, Pageable pageable);

    List<Game> findTop8ByTrangThaiOrderByLuotMuaDesc(String trangThai);

    List<Game> findTop8ByTrangThaiOrderByNgayTaoDesc(String trangThai);

    long countByDanhMucId(Integer idDanhMuc);
}