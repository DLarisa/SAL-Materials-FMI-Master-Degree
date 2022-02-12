package com.example.examen.exceptions;

public class PaymentAlreadyCancelled extends RuntimeException{
    public PaymentAlreadyCancelled() {
        super("The payment is already cancelled");
    }
}
