package com.example.examen.exceptionshandler;

import com.example.examen.exceptions.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler({NegativeAmountError.class,
            PaymentTypeError.class, PaymentStatusTypeError.class,
            InvalidCancelRequestError.class, PaymentNotFoundError.class,
            PaymentAlreadyCancelled.class})
    public ResponseEntity handle(Exception e) {
        return ResponseEntity.badRequest().body(e.getMessage());
    }
}
