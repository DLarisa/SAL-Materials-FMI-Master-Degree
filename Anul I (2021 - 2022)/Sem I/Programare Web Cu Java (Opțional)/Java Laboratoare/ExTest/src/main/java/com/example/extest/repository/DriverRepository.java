package com.example.extest.repository;

import com.example.extest.model.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DriverRepository extends JpaRepository<Driver, Integer> {
    Optional<Driver> findByEmail(String email);
    List<Driver> findByName(String name);
    List<Driver> findByCity(String city);
    List<Driver> findByNameAndCity(String name, String city);
}
