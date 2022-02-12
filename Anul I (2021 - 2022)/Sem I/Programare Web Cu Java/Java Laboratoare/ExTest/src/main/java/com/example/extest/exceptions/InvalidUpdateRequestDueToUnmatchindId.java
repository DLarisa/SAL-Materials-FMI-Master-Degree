package com.example.extest.exceptions;

public class InvalidUpdateRequestDueToUnmatchindId extends RuntimeException{
    public InvalidUpdateRequestDueToUnmatchindId() {
        super("Cannot perform update action due to unmatching of id.");
    }
}
