package com.example.extest.exceptionshandling;

import com.example.extest.exceptions.DriverDuplicateError;
import com.example.extest.exceptions.DriverNotFound;
import com.example.extest.exceptions.InvalidUpdateRequestDueToUnmatchindId;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler({DriverDuplicateError.class,
            InvalidUpdateRequestDueToUnmatchindId.class,
            DriverNotFound.class})
    public ResponseEntity handle(Exception e) {
        return ResponseEntity.badRequest().body(e.getMessage());
    }
}
