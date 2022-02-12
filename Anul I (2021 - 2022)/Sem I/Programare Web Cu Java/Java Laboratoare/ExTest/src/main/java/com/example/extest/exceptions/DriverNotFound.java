package com.example.extest.exceptions;

import com.example.extest.model.Driver;

public class DriverNotFound extends RuntimeException{
    public DriverNotFound(Driver driver) {
        super("The driver with the id " + driver.getDriverId() + " was not found in the database!");
    }
}
