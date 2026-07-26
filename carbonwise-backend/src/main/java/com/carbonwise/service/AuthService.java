package com.carbonwise.service;

import com.carbonwise.dto.AuthDTO;
import com.carbonwise.dto.UserDTO;
import com.carbonwise.entity.User;
import com.carbonwise.repository.UserRepository;
import com.carbonwise.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthDTO.AuthResponse login(AuthDTO.LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getRole());
        String refreshToken = jwtUtil.generateRefreshToken(user.getId());

        return AuthDTO.AuthResponse.builder()
                .token(token)
                .refreshToken(refreshToken)
                .userId(user.getId())
                .role(user.getRole())
                .user(mapToUserDTO(user))
                .build();
    }

    public AuthDTO.AuthResponse register(AuthDTO.RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        User user = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(request.getRole())
                .isVerified(false)
                .createdAt(java.time.LocalDateTime.now())
                .build();

        User saved = userRepository.save(user);

        String token = jwtUtil.generateToken(saved.getId(), saved.getRole());
        String refreshToken = jwtUtil.generateRefreshToken(saved.getId());

        return AuthDTO.AuthResponse.builder()
                .token(token)
                .refreshToken(refreshToken)
                .userId(saved.getId())
                .role(saved.getRole())
                .user(mapToUserDTO(saved))
                .build();
    }

    public boolean verifyOTP(String email, String otp) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        // TODO: Verify OTP from cache/email
        user.setIsVerified(true);
        user.setUpdatedAt(java.time.LocalDateTime.now());
        userRepository.save(user);
        return true;
    }

    public void forgotPassword(String email) {
        // TODO: Send password reset email
    }

    public AuthDTO.AuthResponse refreshToken(String refreshToken) {
        String userId = jwtUtil.extractUserId(refreshToken);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String newToken = jwtUtil.generateToken(user.getId(), user.getRole());

        return AuthDTO.AuthResponse.builder()
                .token(newToken)
                .refreshToken(refreshToken)
                .userId(user.getId())
                .role(user.getRole())
                .user(mapToUserDTO(user))
                .build();
    }

    private UserDTO mapToUserDTO(User user) {
        return UserDTO.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .role(user.getRole())
                .phone(user.getPhone())
                .city(user.getCity())
                .profileImage(user.getProfileImage())
                .isVerified(user.getIsVerified())
                .build();
    }
}
