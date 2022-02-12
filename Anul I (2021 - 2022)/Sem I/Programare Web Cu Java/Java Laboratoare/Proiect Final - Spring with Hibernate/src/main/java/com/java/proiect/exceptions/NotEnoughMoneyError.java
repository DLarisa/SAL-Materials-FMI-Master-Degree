package com.java.proiect.exceptions;

public class NotEnoughMoneyError extends RuntimeException{
    public NotEnoughMoneyError() {
        super("The amount is not sufficient in order to purchase the album!");
    }
}
