package com.example.SellGame.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

/**
 * Cấu hình để Spring Boot phục vụ ảnh từ thư mục uploads/ Khi trình duyệt gọi
 * /uploads/games/abc.jpg → Spring tìm file tại
 * [project_root]/uploads/games/abc.jpg
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Phục vụ ảnh upload từ thư mục ngoài src/main/resources
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/");

        // Static files trong src/main/resources/static
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
}
