package com.example.extest.service;

import com.example.extest.exceptions.DriverDuplicateError;
import com.example.extest.model.Driver;
import com.example.extest.repository.DriverRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class DriverServiceTest {
    @InjectMocks
    private DriverService driverService;

    @Mock
    private DriverRepository driverRepository;

    @Test
    @DisplayName("Driver is created successfully")
    void create() {
        Driver driver = new Driver("Name Test", "emailTest@yahoo.com", "City Test");
        when(driverRepository.findByEmail(driver.getEmail())).thenReturn(Optional.empty());
        when(driverRepository.save(driver)).thenReturn(driver);

        Driver result = driverService.create(driver);

        assertNotNull(result);
        assertEquals(driver.getDriverId(), result.getDriverId());
        assertEquals(driver.getName(), result.getName());
        assertEquals(driver.getEmail(), result.getEmail());
        assertEquals(driver.getCity(), result.getCity());

        verify(driverRepository).findByEmail(driver.getEmail());
        verify(driverRepository).save(driver);
    }

    @Test
    @DisplayName("Driver is NOT created - Email duplicate")
    void createThrowsError() {
        Driver driver = new Driver("Name Test", "emailTest@yahoo.com", "City Test");
        when(driverRepository.findByEmail(driver.getEmail())).thenReturn(Optional.of(driver));

        DriverDuplicateError error = assertThrows(DriverDuplicateError.class,
                () -> driverService.create(driver));

        assertNotNull(error);
        assertEquals("Cannot create driver with this email address. Duplicate found!",
                error.getMessage());

        verify(driverRepository).findByEmail(driver.getEmail());
        verify(driverRepository, times(0)).save(driver);
    }

    @Test
    @DisplayName("Driver name and city are updated successfully")
    void updateNameAndCity() {
        Driver oldDriver = new Driver("Old Test", "oldTest@yahoo.com", "Old Test");
        Driver newDriver = new Driver("New Test", "oldTest@yahoo.com", "New Test");
        when(driverRepository.findById(oldDriver.getDriverId())).thenReturn(Optional.of(oldDriver));
        when(driverRepository.save(newDriver)).thenReturn(newDriver);

        Driver result = driverService.update(newDriver);

        assertNotNull(result);
        assertEquals(newDriver.getDriverId(), result.getDriverId());
        assertEquals(newDriver.getName(), result.getName());
        assertEquals(newDriver.getEmail(), result.getEmail());
        assertEquals(newDriver.getCity(), result.getCity());

        verify(driverRepository).findById(newDriver.getDriverId());
        verify(driverRepository).save(newDriver);
        verify(driverRepository, never()).findByEmail(newDriver.getEmail());
    }

    @Test
    @DisplayName("Driver email is updated successfully")
    void updateEmail() {
        Driver oldDriver = new Driver("Old Test", "oldTest@yahoo.com", "Old Test");
        Driver newDriver = new Driver("New Test", "newTest@yahoo.com", "New Test");
        when(driverRepository.findById(newDriver.getDriverId())).thenReturn(Optional.of(oldDriver));
        when(driverRepository.findByEmail(newDriver.getEmail())).thenReturn(Optional.empty());
        when(driverRepository.save(newDriver)).thenReturn(newDriver);

        Driver result = driverService.update(newDriver);

        assertNotNull(result);
        assertEquals(newDriver.getDriverId(), result.getDriverId());
        assertEquals(newDriver.getName(), result.getName());
        assertEquals(newDriver.getEmail(), result.getEmail());
        assertEquals(newDriver.getCity(), result.getCity());

        verify(driverRepository).findById(newDriver.getDriverId());
        verify(driverRepository).findByEmail(newDriver.getEmail());
        verify(driverRepository).save(newDriver);
    }

    @Test
    @DisplayName("Driver is NOT updated - Email duplicate")
    void updateEmailThrowsError() {
        Driver oldDriver = new Driver(1, "Old Test", "oldTest@yahoo.com", "Old Test");
        Driver newDriver = new Driver(1, "Old Test", "newTest@yahoo.com", "Old Test");
        Driver anotherDriver = new Driver(2, "Another Test", "newTest@yahoo.com", "Another Test");
        when(driverRepository.findById(newDriver.getDriverId())).thenReturn(Optional.of(oldDriver));
        when(driverRepository.findByEmail(newDriver.getEmail())).thenReturn(Optional.of(anotherDriver));

        DriverDuplicateError error = assertThrows(DriverDuplicateError.class,
                () -> driverService.update(newDriver));

        assertNotNull(error);
        assertEquals("Cannot create driver with this email address. Duplicate found!",
                error.getMessage());

        verify(driverRepository).findById(newDriver.getDriverId());
        verify(driverRepository).findByEmail(newDriver.getEmail());
        verify(driverRepository, times(0)).save(newDriver);
    }

    @Test
    @DisplayName("Get drivers by name")
    void getByName() {
        String name = "a";
        Driver driver = new Driver(1, "a", "a@yahoo.com", "city");
        when(driverRepository.findByName(name)).thenReturn(List.of(driver));

        List<Driver> driverList = driverService.get(name, null);

        assertNotNull(driverList);
        assertEquals(1, driverList.size());
        assertEquals(driver, driverList.get(0));

        verify(driverRepository).findByName(name);
        verify(driverRepository, never()).findByNameAndCity(any(), any());
        verify(driverRepository, never()).findByCity(any());
        verify(driverRepository, never()).findAll();
    }
}
