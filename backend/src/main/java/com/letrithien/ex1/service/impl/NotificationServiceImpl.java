package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Notification;
import com.letrithien.ex1.repository.NotificationRepository;
import com.letrithien.ex1.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository notificationRepository;

    @Override
    public List<Notification> findAll() {
        return notificationRepository.findAll();
    }

    @Override
    public Notification findById(UUID id) {
        return notificationRepository.findById(id).orElseThrow(() -> new RuntimeException("Notification not found"));
    }

    @Override
    public Notification save(Notification entity) {
        return notificationRepository.save(entity);
    }

    @Override
    public Notification update(UUID id, Notification entity) {
        Notification existing = findById(id);
        // TODO: Map fields
        return notificationRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        notificationRepository.deleteById(id);
    }
}
