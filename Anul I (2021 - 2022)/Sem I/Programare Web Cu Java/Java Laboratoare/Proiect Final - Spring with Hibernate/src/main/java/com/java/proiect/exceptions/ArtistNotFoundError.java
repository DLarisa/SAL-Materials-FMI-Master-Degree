package com.java.proiect.exceptions;

import com.java.proiect.model.Artist;

public class ArtistNotFoundError extends RuntimeException{
    public ArtistNotFoundError() {
        super("The artist was not found in the database!");
    }
}
