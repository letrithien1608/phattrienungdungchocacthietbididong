package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Category;
import com.letrithien.ex1.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public List<Category> getAllCategories() {
        List<Category> categories = categoryRepository.findAllByOrderByCreatedAtDesc();
        
        // Đảo ngược lại để xếp theo thứ tự cũ nhất -> mới nhất (tức là thứ tự bạn đã tạo: New, Clothes, Shoes, Accessories)
        java.util.Collections.reverse(categories);
        
        // Đảm bảo "New" luôn nằm đầu tiên nếu có
        categories.sort((c1, c2) -> {
            if ("New".equalsIgnoreCase(c1.getCategoryName())) return -1;
            if ("New".equalsIgnoreCase(c2.getCategoryName())) return 1;
            return 0;
        });
        
        return categories;
    }

    public Category createCategory(Category category) {
        return categoryRepository.save(category);
    }

    public Category updateCategory(java.util.UUID id, Category updatedCategory) {
        Category existingCategory = categoryRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Category not found"));
        
        if (updatedCategory.getCategoryName() != null) existingCategory.setCategoryName(updatedCategory.getCategoryName());
        if (updatedCategory.getCategoryDescription() != null) existingCategory.setCategoryDescription(updatedCategory.getCategoryDescription());
        if (updatedCategory.getIcon() != null) existingCategory.setIcon(updatedCategory.getIcon());
        if (updatedCategory.getImage() != null) existingCategory.setImage(updatedCategory.getImage());
        if (updatedCategory.getPlaceholder() != null) existingCategory.setPlaceholder(updatedCategory.getPlaceholder());
        if (updatedCategory.getActive() != null) existingCategory.setActive(updatedCategory.getActive());
        if (updatedCategory.getParentId() != null) existingCategory.setParentId(updatedCategory.getParentId());
        
        existingCategory.setUpdatedAt(java.time.LocalDateTime.now());
        
        return categoryRepository.save(existingCategory);
    }
}
