package com.example.extest.mapper;

import com.example.extest.dto.CreateDriverDto;
import com.example.extest.dto.UpdateDriverDto;
import com.example.extest.model.Driver;
import org.springframework.stereotype.Component;

@Component
public class DriverMapper {
    public Driver createDriverDtoToDriver(CreateDriverDto createDriverDto) {
        return new Driver(createDriverDto.getName(), createDriverDto.getEmail(), createDriverDto.getCity());
    }

    public Driver updateDriverDtoToDriver(UpdateDriverDto request) {
        return new Driver(request.getId(), request.getName(), request.getEmail(), request.getCity());
    }
}
