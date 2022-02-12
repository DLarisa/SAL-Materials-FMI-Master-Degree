package com.java.proiect.exceptions;

public class DuplicateGenreError extends RuntimeException{
    public DuplicateGenreError() {
        super("Duplicate genre error!");
    }
}
