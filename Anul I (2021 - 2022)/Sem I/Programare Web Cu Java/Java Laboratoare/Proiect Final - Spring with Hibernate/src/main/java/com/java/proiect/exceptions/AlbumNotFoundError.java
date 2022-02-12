package com.java.proiect.exceptions;

public class AlbumNotFoundError extends RuntimeException{
    public AlbumNotFoundError() {
        super("Album not found in the database!");
    }
}
