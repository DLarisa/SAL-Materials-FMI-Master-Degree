package com.java.proiect.exceptions;

public class PriceOrQuantityNegativeError extends RuntimeException{
    public PriceOrQuantityNegativeError() {
        super("The action was not performed due to negative data present on request! (price/quantity)");
    }
}
