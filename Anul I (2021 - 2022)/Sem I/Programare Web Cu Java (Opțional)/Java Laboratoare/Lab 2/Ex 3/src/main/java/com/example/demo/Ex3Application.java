package com.example.demo;

import com.example.demo.aspects.MainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Ex3Application implements CommandLineRunner {

    @Autowired
    public MainService mainService;

    public static void main(String[] args) {
        SpringApplication.run(Ex3Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println(mainService.getLowerCaseName("Test 123"));
        System.out.println(mainService.getUpperCaseName("Test 456"));
    }
}
