package com.java.proiect.exceptions;

public class InvalidRequestUnmatchedId extends RuntimeException{
    public InvalidRequestUnmatchedId() {
        super("Cannot perform action due to unmatched id provided!");
    }
    public InvalidRequestUnmatchedId(int id) {
        super("The artist is not from the group with the id: " + id);
    }
}
