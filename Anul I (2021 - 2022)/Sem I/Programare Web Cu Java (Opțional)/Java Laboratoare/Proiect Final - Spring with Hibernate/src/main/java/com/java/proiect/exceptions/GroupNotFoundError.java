package com.java.proiect.exceptions;

import com.java.proiect.model.Group;

public class GroupNotFoundError extends RuntimeException{
    public GroupNotFoundError(Group group) {
        super("The group with the id " + group.getGroupId() + " was not found in the database!");
    }
    public GroupNotFoundError() {
        super("Not found in the database!");
    }
}
