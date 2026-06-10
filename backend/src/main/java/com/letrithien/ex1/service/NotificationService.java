package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Notification;
import java.util.List;
import java.util.UUID;

public interface NotificationService {
    List<Notification> findAll();
    Notification findById(UUID id);
    Notification save(Notification entity);
    Notification update(UUID id, Notification entity);
    void delete(UUID id);
}
