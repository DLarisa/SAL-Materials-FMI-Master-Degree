package com.example.extest.service;

import com.example.extest.exceptions.DriverDuplicateError;
import com.example.extest.exceptions.DriverNotFound;
import com.example.extest.model.Driver;
import com.example.extest.repository.DriverRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DriverService {
    public final DriverRepository driverRepository;

    @Autowired
    public DriverService(DriverRepository driverRepository) {
        this.driverRepository = driverRepository;
    }

    public Driver create(Driver driver) {
        checkUniqueEmail(driver);
        return driverRepository.save(driver);
    }

    private void checkUniqueEmail(Driver driver) {
        Optional<Driver> existingDriver = driverRepository.findByEmail(driver.getEmail());
        if(existingDriver.isPresent()) {
            throw new DriverDuplicateError();
        }
    }

    public Driver update(Driver driver) {
        Optional<Driver> foundDriver = driverRepository.findById(driver.getDriverId());
        if(foundDriver.isEmpty()) {
            throw new DriverNotFound(driver);
        }
        if(!driver.getEmail().equals(foundDriver.get().getEmail())) {
            checkUniqueEmail(driver);
        }
        return driverRepository.save(driver);
    }

    public List<Driver> get(String name, String city) {
        if(name != null) {
            if(city != null) {
                return driverRepository.findByNameAndCity(name, city);
            }
            return driverRepository.findByName(name);
        }
        if(city != null) {
            return driverRepository.findByCity(city);
        }
        return driverRepository.findAll();
    }
}
