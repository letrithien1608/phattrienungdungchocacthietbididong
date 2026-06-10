package com.letrithien.ex1.service;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    public void sendPasswordResetMail(String toEmail, String resetLink) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Yêu cầu cấp lại mật khẩu - App của Thiện");
        message.setText("Xin chào,\n\n" +
                "Bạn đã yêu cầu đặt lại mật khẩu. Vui lòng click vào đường link bên dưới để tạo mật khẩu mới:\n" +
                resetLink + "\n\n" +
                "Link này sẽ hết hạn sau 15 phút.\n" +
                "Nếu bạn không yêu cầu, vui lòng bỏ qua email này.");

        mailSender.send(message);
    }
}