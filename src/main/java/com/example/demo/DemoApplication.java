package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
@RestController
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Hello from Tekton + ArgoCD Demo!");
        response.put("timestamp", LocalDateTime.now());
        response.put("version", "1.0.0");
        return response;
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/api/info")
    public Map<String, Object> info() {
        Map<String, Object> response = new HashMap<>();
        response.put("app", "tekton-argocd-demo");
        response.put("description", "CI/CD Demo with Tekton and ArgoCD");
        response.put("author", "Developer");
        return response;
    }
}