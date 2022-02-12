package com.java.proiect.exceptions;

public class ArtistAlreadyInGroupError extends RuntimeException{
    public ArtistAlreadyInGroupError() {
        super("The artist is already in the group!");
    }
}
