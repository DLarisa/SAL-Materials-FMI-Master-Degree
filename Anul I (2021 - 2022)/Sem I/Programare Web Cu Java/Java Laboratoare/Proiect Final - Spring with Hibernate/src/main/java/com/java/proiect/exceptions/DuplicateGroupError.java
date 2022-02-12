package com.java.proiect.exceptions;

import com.java.proiect.model.Group;

public class DuplicateGroupError extends RuntimeException{
    public DuplicateGroupError(Group group) {
        super("There is already a group with the name: " + group.getName());
    }
}
