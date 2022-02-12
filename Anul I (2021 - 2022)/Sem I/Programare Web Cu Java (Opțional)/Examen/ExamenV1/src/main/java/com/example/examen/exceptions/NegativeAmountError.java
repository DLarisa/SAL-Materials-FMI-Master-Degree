package com.example.examen.exceptions;

public class NegativeAmountError extends RuntimeException{
    public NegativeAmountError() {
        super("Amount cannot be negative!");
    }
}
