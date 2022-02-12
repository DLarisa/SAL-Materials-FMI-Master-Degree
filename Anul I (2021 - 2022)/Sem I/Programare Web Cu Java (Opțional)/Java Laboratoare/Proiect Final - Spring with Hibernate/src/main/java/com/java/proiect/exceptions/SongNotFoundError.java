package com.java.proiect.exceptions;

public class SongNotFoundError extends RuntimeException{
    public SongNotFoundError() {
        super("The song was not found in the database!");
    }
}
