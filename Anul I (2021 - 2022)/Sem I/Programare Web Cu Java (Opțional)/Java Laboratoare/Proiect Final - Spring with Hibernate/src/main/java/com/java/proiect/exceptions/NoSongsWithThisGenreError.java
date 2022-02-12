package com.java.proiect.exceptions;

public class NoSongsWithThisGenreError extends RuntimeException{
    public NoSongsWithThisGenreError(String type) {
        super("No songs with genre " + type + " were found in the database!");
    }
}
