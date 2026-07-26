package com.carbonwise.service;
import com.carbonwise.dto.AuthDTO; import com.carbonwise.dto.UserDTO; import com.carbonwise.entity.User;
import com.carbonwise.mapper.UserMapper; import com.carbonwise.repository.UserRepository;
import com.carbonwise.security.JwtUtil; import com.carbonwise.validation.AuthValidation;
import lombok.RequiredArgsConstructor; import org.springframework.security.crypto.password.PasswordEncoder; import org.springframework.stereotype.Service;
import java.time.LocalDateTime;

@Service @RequiredArgsConstructor
public class AuthService {
    private final UserRepository userRepository; private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil; private final UserMapper userMapper; private final AuthValidation authValidation;
    public AuthDTO.AuthResponse login(AuthDTO.LoginRequest request) {
        authValidation.validateLogin(request);
        User user = userRepository.findByEmail(request.getEmail()).orElseThrow(() -> new RuntimeException("User not found"));
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) throw new RuntimeException("Invalid password");
        String token = jwtUtil.generateToken(user.getId(), user.getRole()); String refreshToken = jwtUtil.generateRefreshToken(user.getId());
        return AuthDTO.AuthResponse.builder().token(token).refreshToken(refreshToken).userId(user.getId()).role(user.getRole()).user(userMapper.toDTO(user)).build();
    }
    public AuthDTO.AuthResponse register(AuthDTO.RegisterRequest request) {
        authValidation.validateRegister(request);
        if (userRepository.existsByEmail(request.getEmail())) throw new RuntimeException("Email already exists");
        User user = User.builder().name(request.getName()).email(request.getEmail()).password(passwordEncoder.encode(request.getPassword())).role(request.getRole()).isVerified(false).createdAt(LocalDateTime.now()).build();
        User saved = userRepository.save(user);
        return AuthDTO.AuthResponse.builder().token(jwtUtil.generateToken(saved.getId(), saved.getRole())).refreshToken(jwtUtil.generateRefreshToken(saved.getId())).userId(saved.getId()).role(saved.getRole()).user(userMapper.toDTO(saved)).build();
    }
    public boolean verifyOTP(String email, String otp) { User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found")); user.setIsVerified(true); user.setUpdatedAt(LocalDateTime.now()); userRepository.save(user); return true; }
    public void forgotPassword(String email) { /* TODO: Send password reset email */ }
    public AuthDTO.AuthResponse refreshToken(String refreshToken) { String userId = jwtUtil.extractUserId(refreshToken); User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found")); return AuthDTO.AuthResponse.builder().token(jwtUtil.generateToken(user.getId(), user.getRole())).refreshToken(refreshToken).userId(user.getId()).role(user.getRole()).user(userMapper.toDTO(user)).build(); }
}
