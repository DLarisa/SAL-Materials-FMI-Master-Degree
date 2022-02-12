package com.java.proiect.exceptions;

import com.java.proiect.model.Group;

public class NoMembersNotEqualError extends RuntimeException{
    public NoMembersNotEqualError(Group group) {
        super("The number of members provided (" + group.getNoMembers() + ") is not equal to " +
                "the number of members from the list of artists (" + group.getArtists().size() +
                ")!");
    }
}
