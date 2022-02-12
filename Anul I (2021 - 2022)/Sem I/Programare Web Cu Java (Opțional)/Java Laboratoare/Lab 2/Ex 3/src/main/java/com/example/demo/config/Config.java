package com.example.demo.config;

import com.example.demo.aspects.MyAspect;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@Configuration
@EnableAspectJAutoProxy // tb dat enable ca să știe că lucrăm cu aspecte
public class Config {
    @Bean
    public MyAspect myAspect() {
        return new MyAspect();
    }
}
