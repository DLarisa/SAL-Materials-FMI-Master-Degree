package com.java.proiect.exceptions;

public class NotAvailableLanguageType extends RuntimeException{
    public NotAvailableLanguageType() {
        super("The language is not yet available or it might be incorrect!");
    }
}
