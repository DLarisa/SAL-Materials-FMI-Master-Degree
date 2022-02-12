package com.example.examen.exceptions;

public class PaymentNotFoundError extends RuntimeException{
    public PaymentNotFoundError() {
        super("The payment does not exist!");
    }
}
