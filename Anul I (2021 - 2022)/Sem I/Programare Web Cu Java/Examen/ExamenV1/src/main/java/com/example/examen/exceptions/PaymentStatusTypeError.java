package com.example.examen.exceptions;

public class PaymentStatusTypeError extends RuntimeException{
    public PaymentStatusTypeError() {
        super("Status type incorrect!");
    }
}
