package com.carbonwise.controller;
import com.carbonwise.dto.AuthDTO;
import com.carbonwise.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController @RequestMapping("/api/auth") @RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;
    @PostMapping("/login") public ResponseEntity<AuthDTO.AuthResponse> login(@RequestBody AuthDTO.LoginRequest request) { return ResponseEntity.ok(authService.login(request)); }
    @PostMapping("/register") public ResponseEntity<AuthDTO.AuthResponse> register(@RequestBody AuthDTO.RegisterRequest request) { return ResponseEntity.ok(authService.register(request)); }
    @PostMapping("/verifyOTP") public ResponseEntity<Boolean> verifyOTP(@RequestBody AuthDTO.OTPRequest request) { return ResponseEntity.ok(authService.verifyOTP(request.getEmail(), request.getOtp())); }
    @PostMapping("/forgotPassword") public ResponseEntity<Void> forgotPassword(@RequestBody AuthDTO.ForgotPasswordRequest request) { authService.forgotPassword(request.getEmail()); return ResponseEntity.ok().build(); }
    @PostMapping("/refresh") public ResponseEntity<AuthDTO.AuthResponse> refreshToken(@RequestBody String refreshToken) { return ResponseEntity.ok(authService.refreshToken(refreshToken)); }
}
