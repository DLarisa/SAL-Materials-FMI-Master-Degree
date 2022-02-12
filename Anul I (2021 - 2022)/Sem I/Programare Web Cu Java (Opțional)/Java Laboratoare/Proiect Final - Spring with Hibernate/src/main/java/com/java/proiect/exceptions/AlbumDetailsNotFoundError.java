package com.java.proiect.exceptions;

public class AlbumDetailsNotFoundError extends RuntimeException{
    public AlbumDetailsNotFoundError() {
        super("Album Details not found in the database!");
    }
}
