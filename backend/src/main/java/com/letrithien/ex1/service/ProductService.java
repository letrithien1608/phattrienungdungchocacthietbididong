package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Product;
import com.letrithien.ex1.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;

    public List<Product> getAllProducts() {
        return productRepository.findByPublishedTrueOrderByCreatedAtAsc();
    }

    public List<Product> getNewProducts() {
        return productRepository.findByPublishedTrueAndShortDescriptionOrderByCreatedAtAsc("New");
    }

    public List<Product> getSaleProducts() {
        return productRepository.findByPublishedTrueAndShortDescriptionOrderByCreatedAtAsc("Sale");
    }

    public Product createProduct(Product product) {
        // Mặc định luôn publish khi tạo từ Postman để test cho lẹ
        if (product.getPublished() == null) {
            product.setPublished(true);
        }
        return productRepository.save(product);
    }

    public void deleteAllProducts() {
        productRepository.deleteAll();
    }

    public void deleteProduct(java.util.UUID id) {
        productRepository.deleteById(id);
    }

    public Product updateProduct(java.util.UUID id, Product updatedProduct) {
        Product existingProduct = productRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Product not found"));
        
        if (updatedProduct.getProductName() != null) existingProduct.setProductName(updatedProduct.getProductName());
        if (updatedProduct.getSlug() != null) existingProduct.setSlug(updatedProduct.getSlug());
        if (updatedProduct.getSku() != null) existingProduct.setSku(updatedProduct.getSku());
        if (updatedProduct.getSalePrice() != null) existingProduct.setSalePrice(updatedProduct.getSalePrice());
        if (updatedProduct.getComparePrice() != null) existingProduct.setComparePrice(updatedProduct.getComparePrice());
        if (updatedProduct.getBuyingPrice() != null) existingProduct.setBuyingPrice(updatedProduct.getBuyingPrice());
        if (updatedProduct.getQuantity() != null) existingProduct.setQuantity(updatedProduct.getQuantity());
        if (updatedProduct.getShortDescription() != null) existingProduct.setShortDescription(updatedProduct.getShortDescription());
        if (updatedProduct.getProductDescription() != null) existingProduct.setProductDescription(updatedProduct.getProductDescription());
        if (updatedProduct.getProductType() != null) existingProduct.setProductType(updatedProduct.getProductType());
        if (updatedProduct.getImage() != null) existingProduct.setImage(updatedProduct.getImage());
        if (updatedProduct.getPublished() != null) existingProduct.setPublished(updatedProduct.getPublished());
        if (updatedProduct.getDisableOutOfStock() != null) existingProduct.setDisableOutOfStock(updatedProduct.getDisableOutOfStock());
        if (updatedProduct.getNote() != null) existingProduct.setNote(updatedProduct.getNote());
        
        existingProduct.setUpdatedAt(java.time.LocalDateTime.now());
        
        return productRepository.save(existingProduct);
    }
}
