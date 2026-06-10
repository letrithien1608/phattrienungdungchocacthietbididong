import os
import re

BASE_DIR = r"C:\Users\ASUS\Documents\JavaString\ex1\src\main\java\com\letrithien\ex1"
ENTITY_DIR = os.path.join(BASE_DIR, "entity")
REPO_DIR = os.path.join(BASE_DIR, "repository")
SERVICE_DIR = os.path.join(BASE_DIR, "service")
SERVICE_IMPL_DIR = os.path.join(SERVICE_DIR, "impl")
CONTROLLER_DIR = os.path.join(BASE_DIR, "controller")

PACKAGE_BASE = "com.letrithien.ex1"

for d in [REPO_DIR, SERVICE_DIR, SERVICE_IMPL_DIR, CONTROLLER_DIR]:
    if not os.path.exists(d):
        os.makedirs(d)

def get_id_type(entity_file):
    with open(entity_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # find @Id then the next 'private Type name;'
    match = re.search(r'@Id.*?(?:@GeneratedValue[^;]*?)?.*?private\s+([A-Za-z0-9_]+)\s+[A-Za-z0-9_]+', content, re.DOTALL)
    if match:
        return match.group(1)
    return "UUID" # default

def generate():
    entities = [f for f in os.listdir(ENTITY_DIR) if f.endswith('.java')]
    
    for entity_file in entities:
        entity_name = entity_file.replace('.java', '')
        if entity_name in ['Role', 'StaffAccount']:
            print(f"Skipping {entity_name}")
            continue
            
        id_type = get_id_type(os.path.join(ENTITY_DIR, entity_file))
        print(f"[{entity_name}] ID type: {id_type}")
        
        # 1. Repository
        repo_file = os.path.join(REPO_DIR, f"{entity_name}Repository.java")
        content = f"""package {PACKAGE_BASE}.repository;

import {PACKAGE_BASE}.entity.{entity_name};
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

{f'import java.util.UUID;' if id_type == 'UUID' else ''}

@Repository
public interface {entity_name}Repository extends JpaRepository<{entity_name}, {id_type}> {{
}}
"""
        with open(repo_file, 'w', encoding='utf-8') as f:
            f.write(content)

        # 2. Service Interface
        service_file = os.path.join(SERVICE_DIR, f"{entity_name}Service.java")
        # Only overwrite if it's an interface (to avoid destroying CategoryService, ProductService)
        if os.path.exists(service_file):
            with open(service_file, 'r', encoding='utf-8') as f:
                is_interface = 'interface' in f.read()
            if not is_interface:
                print(f"Skipping {entity_name}Service (already a class)")
                continue
                
        content = f"""package {PACKAGE_BASE}.service;

import {PACKAGE_BASE}.entity.{entity_name};
import java.util.List;
{f'import java.util.UUID;' if id_type == 'UUID' else ''}

public interface {entity_name}Service {{
    List<{entity_name}> findAll();
    {entity_name} findById({id_type} id);
    {entity_name} save({entity_name} entity);
    {entity_name} update({id_type} id, {entity_name} entity);
    void delete({id_type} id);
}}
"""
        with open(service_file, 'w', encoding='utf-8') as f:
            f.write(content)
            
        # 3. Service Impl
        impl_file = os.path.join(SERVICE_IMPL_DIR, f"{entity_name}ServiceImpl.java")
        var_name = entity_name[0].lower() + entity_name[1:]
        content = f"""package {PACKAGE_BASE}.service.impl;

import {PACKAGE_BASE}.entity.{entity_name};
import {PACKAGE_BASE}.repository.{entity_name}Repository;
import {PACKAGE_BASE}.service.{entity_name}Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
{f'import java.util.UUID;' if id_type == 'UUID' else ''}

@Service
@RequiredArgsConstructor
public class {entity_name}ServiceImpl implements {entity_name}Service {{

    private final {entity_name}Repository {var_name}Repository;

    @Override
    public List<{entity_name}> findAll() {{
        return {var_name}Repository.findAll();
    }}

    @Override
    public {entity_name} findById({id_type} id) {{
        return {var_name}Repository.findById(id).orElseThrow(() -> new RuntimeException("{entity_name} not found"));
    }}

    @Override
    public {entity_name} save({entity_name} entity) {{
        return {var_name}Repository.save(entity);
    }}

    @Override
    public {entity_name} update({id_type} id, {entity_name} entity) {{
        {entity_name} existing = findById(id);
        // TODO: Map fields
        return {var_name}Repository.save(existing);
    }}

    @Override
    public void delete({id_type} id) {{
        {var_name}Repository.deleteById(id);
    }}
}}
"""
        with open(impl_file, 'w', encoding='utf-8') as f:
            f.write(content)

        # 4. Controller
        controller_file = os.path.join(CONTROLLER_DIR, f"{entity_name}Controller.java")
        # Only rewrite if it has "public ResponseEntity<List" to keep existing intact
        can_rewrite = True
        if os.path.exists(controller_file):
            with open(controller_file, 'r', encoding='utf-8') as f:
                if 'TODO' not in f.read() and 'return ResponseEntity.ok(null);' not in f.read():
                    can_rewrite = False # Don't rewrite real controllers

        if can_rewrite or not os.path.exists(controller_file):
            var_name = entity_name[0].lower() + entity_name[1:]
            content = f"""package {PACKAGE_BASE}.controller;

import {PACKAGE_BASE}.entity.{entity_name};
import {PACKAGE_BASE}.service.{entity_name}Service;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
{f'import java.util.UUID;' if id_type == 'UUID' else ''}

@RestController
@RequestMapping("/api/{var_name}s")
@RequiredArgsConstructor
public class {entity_name}Controller {{

    private final {entity_name}Service {var_name}Service;

    @GetMapping
    public ResponseEntity<List<{entity_name}>> getAll() {{
        return ResponseEntity.ok(null); // TODO: use {var_name}Service.findAll() if appropriate
    }}
}}
"""
            with open(controller_file, 'w', encoding='utf-8') as f:
                f.write(content)

if __name__ == "__main__":
    generate()
