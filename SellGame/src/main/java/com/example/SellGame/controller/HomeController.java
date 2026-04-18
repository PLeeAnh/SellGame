package com.example.SellGame.controller;

import com.example.SellGame.Service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private GameService gameService;

    /**
     * Trang chủ: /
     * Truyền gameHot và gameMoi vào view
     * Minh sẽ dùng 2 biến này để hiển thị game trên home.html
     */
    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("gameHot",  gameService.layGameHot());
        model.addAttribute("gameMoi",  gameService.layGameMoi());
        return "customer/home";
    }
}
