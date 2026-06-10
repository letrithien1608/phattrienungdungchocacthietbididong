package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.PasswordResetToken;
import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.repository.PasswordResetTokenRepository;
import com.letrithien.ex1.repository.UserRepository;
import com.letrithien.ex1.security.JwtService;
import lombok.RequiredArgsConstructor;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Import thư viện bị thiếu
import org.springframework.web.client.RestTemplate;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.ResponseEntity;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    // Gộp tất cả các dependency lên đầu và dùng final cho đồng bộ
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final PasswordResetTokenRepository tokenRepository;
    private final EmailService emailService;

    public String register(Map<String, Object> request) {
        String email = (String) request.get("email");
        String name = (String) request.get("name");
        String password = (String) request.get("password");

        if (userRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email đã tồn tại");
        }
        User user = new User();
        if (name == null) name = "";
        String[] parts = name.split(" ", 2);
        user.setFirstName(parts[0]);
        user.setLastName(parts.length > 1 ? parts[1] : "");
        user.setPhoneNumber("");
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setProvider("local");
        user.setProviderId(""); // Tránh null
        user.setImage(""); // Tránh null
        user.setPlaceholder(""); // Tránh null
        user.setRoleName("ROLE_USER");
        user.setPrivileges("staff_read_privilege");
        
        userRepository.save(user);
        return jwtService.generateToken(user);
    }

    public String login(Map<String, Object> request) {
        String email = (String) request.get("email");
        String password = (String) request.get("password");

        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(email, password)
        );
        User user = userRepository.findByEmail(email)
                .orElseThrow();
        return jwtService.generateToken(user);
    }

    public String socialLogin(Map<String, Object> request) {
        String email = ""; 
        String name = "";
        String providerId = "";
        String provider = (String) request.get("provider");
        String token = (String) request.get("token");
        String action = (String) request.get("action");

        if ("google".equals(provider)) {
            SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
            factory.setConnectTimeout(5000);
            factory.setReadTimeout(5000);
            RestTemplate restTemplate = new RestTemplate(factory);
            String url = "https://oauth2.googleapis.com/tokeninfo?id_token=" + token;
            try {
                ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);
                if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                    email = (String) response.getBody().get("email");
                    name = (String) response.getBody().get("name");
                    providerId = (String) response.getBody().get("sub");
                } else {
                    throw new RuntimeException("Token Google không hợp lệ");
                }
            } catch (Exception e) {
                throw new RuntimeException("Lỗi xác thực Google: " + e.getMessage());
            }
        } else if ("facebook".equals(provider)) {
            SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
            factory.setConnectTimeout(5000);
            factory.setReadTimeout(5000);
            RestTemplate restTemplate = new RestTemplate(factory);
            String url = "https://graph.facebook.com/me?fields=id,name,email&access_token=" + token;
            try {
                ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);
                if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                    email = (String) response.getBody().get("email");
                    name = (String) response.getBody().get("name");
                    providerId = (String) response.getBody().get("id");
                    if (email == null) {
                        email = providerId + "@facebook.com"; // Fallback nếu user không cấp quyền email
                    }
                } else {
                    throw new RuntimeException("Token Facebook không hợp lệ");
                }
            } catch (Exception e) {
                throw new RuntimeException("Lỗi xác thực Facebook: " + e.getMessage());
            }
        } else {
            throw new RuntimeException("Provider không được hỗ trợ");
        }

        final String finalEmail = email;
        final String finalName = name;
        final String finalProviderId = providerId;

        if ("login".equals(action)) {
            User user = userRepository.findByEmail(finalEmail)
                    .orElseThrow(() -> new RuntimeException("Tài khoản không tồn tại, vui lòng đăng kí."));
            return jwtService.generateToken(user);
        } else if ("signup".equals(action)) {
            if (userRepository.findByEmail(finalEmail).isPresent()) {
                throw new RuntimeException("Tài khoản đã tồn tại, vui lòng đăng nhập.");
            }
            User newUser = new User();
            newUser.setEmail(finalEmail);
            String nameToSplit = finalName != null ? finalName : "";
            String[] parts = nameToSplit.split(" ", 2);
            newUser.setFirstName(parts[0]);
            newUser.setLastName(parts.length > 1 ? parts[1] : "");
            newUser.setPhoneNumber("");
            newUser.setPassword(passwordEncoder.encode(java.util.UUID.randomUUID().toString()));
            newUser.setProvider(provider);
            newUser.setProviderId(finalProviderId);
            newUser.setImage(""); // Tránh null
            newUser.setPlaceholder(""); // Tránh null
            newUser.setRoleName("ROLE_USER");
            newUser.setPrivileges("staff_read_privilege");
            userRepository.save(newUser);
            return jwtService.generateToken(newUser);
        } else {
            // Hỗ trợ ngược cho các app chưa cập nhật action
            User user = userRepository.findByEmail(finalEmail).orElseGet(() -> {
                User newUser = new User();
                newUser.setEmail(finalEmail);
                String nameToSplit = finalName != null ? finalName : "";
                String[] parts = nameToSplit.split(" ", 2);
                newUser.setFirstName(parts[0]);
                newUser.setLastName(parts.length > 1 ? parts[1] : "");
                newUser.setPhoneNumber("");
                newUser.setPassword(passwordEncoder.encode(java.util.UUID.randomUUID().toString()));
                newUser.setProvider(provider);
                newUser.setProviderId(finalProviderId);
                newUser.setImage(""); // Tránh null
                newUser.setPlaceholder(""); // Tránh null
                newUser.setRoleName("ROLE_USER");
                newUser.setPrivileges("staff_read_privilege");
                return userRepository.save(newUser);
            });
            return jwtService.generateToken(user);
        }
    }

    @Transactional
    public void processForgotPassword(Map<String, Object> request) {
        String email = (String) request.get("email");
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy email này trong hệ thống"));

        // Xóa token cũ nếu có
        tokenRepository.deleteByUser_Id(user.getId());

        // Tạo token ngẫu nhiên (UUID)
        String token = java.util.UUID.randomUUID().toString();
        PasswordResetToken resetToken = new PasswordResetToken(token, user);
        tokenRepository.save(resetToken);

        // Tạo link reset (Trong thực tế đây sẽ là link Deep link mở Mobile App hoặc link Web Frontend)
        // Ví dụ: myapp://reset-password?token=abc-xyz
        String resetLink = "http://localhost:8080/api/auth/reset-password?token=" + token;
        
        emailService.sendPasswordResetMail(user.getEmail(), resetLink);
        System.out.println("====== TOKEN ĐỂ TEST LÀ: " + token + " ======");
    }

    public void resetPassword(Map<String, Object> request) {
        String token = (String) request.get("token");
        String newPassword = (String) request.get("newPassword");
        
        PasswordResetToken resetToken = tokenRepository.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Token không hợp lệ hoặc không tồn tại"));

        if (resetToken.isExpired()) {
            tokenRepository.delete(resetToken);
            throw new RuntimeException("Token đã hết hạn. Vui lòng yêu cầu lại.");
        }

        User user = resetToken.getUser();
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        // Xóa token sau khi dùng xong
        tokenRepository.delete(resetToken);
    }
}