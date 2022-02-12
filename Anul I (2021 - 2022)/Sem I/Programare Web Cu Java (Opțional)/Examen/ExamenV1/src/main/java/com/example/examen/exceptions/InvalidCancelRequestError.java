package com.example.examen.exceptions;

public class InvalidCancelRequestError extends RuntimeException{
    public InvalidCancelRequestError() {
        super("Ids dont match");
    }
}
