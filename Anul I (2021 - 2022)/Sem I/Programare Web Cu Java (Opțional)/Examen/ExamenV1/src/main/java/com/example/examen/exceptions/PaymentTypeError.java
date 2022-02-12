package com.example.examen.exceptions;

public class PaymentTypeError extends RuntimeException{
    public PaymentTypeError() {
        super("Not correct payment type!");
    }
}
