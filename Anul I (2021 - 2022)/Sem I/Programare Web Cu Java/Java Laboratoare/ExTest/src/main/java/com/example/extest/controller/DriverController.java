package com.example.extest.controller;

import com.example.extest.dto.CreateDriverDto;
import com.example.extest.dto.UpdateDriverDto;
import com.example.extest.exceptions.InvalidUpdateRequestDueToUnmatchindId;
import com.example.extest.mapper.DriverMapper;
import com.example.extest.model.Driver;
import com.example.extest.service.DriverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/driver")
@Validated
public class DriverController {
    private final DriverService driverService;
    private final DriverMapper driverMapper;

    @Autowired
    public DriverController(DriverService driverService, DriverMapper driverMapper) {
        this.driverService = driverService;
        this.driverMapper = driverMapper;
    }

    // Add a new driver
    @PostMapping
    public ResponseEntity<?> create(@Valid
                                    @RequestBody CreateDriverDto createDriverDto) {
        Driver driver = driverService.create(driverMapper.createDriverDtoToDriver(createDriverDto));
        return ResponseEntity.created(URI.create("/driver/" + driver.getDriverId())).body(driver);
    }

    // Update a driver
    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable int id,
                                    @Valid
                                    @RequestBody UpdateDriverDto updateDriverDto) {
        if(id != updateDriverDto.getId()) {
            throw new InvalidUpdateRequestDueToUnmatchindId();
        }
        Driver driver = driverService.update(driverMapper.updateDriverDtoToDriver(updateDriverDto));
        return ResponseEntity.ok(driver);
    }

    // Get list of driver by name and/or city
    @GetMapping
    public List<Driver> get(@RequestParam(required = false) String name,
                            @RequestParam(required = false) String city) {
        return driverService.get(name, city);
    }
}
