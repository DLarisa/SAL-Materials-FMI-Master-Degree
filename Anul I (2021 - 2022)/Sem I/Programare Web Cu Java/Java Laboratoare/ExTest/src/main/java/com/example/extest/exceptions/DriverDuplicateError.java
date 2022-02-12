package com.example.extest.exceptions;

public class DriverDuplicateError extends RuntimeException{
    public DriverDuplicateError() {
        super("Cannot create driver with this email address. Duplicate found!");
    }
}
