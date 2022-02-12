package com.java.proiect.exceptions;

public class NotInStockError extends RuntimeException{
    public NotInStockError() {
        super("The album is no longer in stock. We apologise! :(");
    }
}
