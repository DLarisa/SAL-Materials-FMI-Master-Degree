package com.java.proiect.exceptions;

import com.java.proiect.model.Artist;

public class DuplicateArtistStageNameError extends RuntimeException{
    public DuplicateArtistStageNameError(Artist artist) {
        super("There is already an artist with the stage name: " + artist.getStageName());
    }
}
