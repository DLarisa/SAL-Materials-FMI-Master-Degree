package com.java.proiect.exceptions;

import com.java.proiect.model.Album;

public class NoTracksNotEqualError extends RuntimeException{
    public NoTracksNotEqualError(Album album) {
        super("No of tracks provided (" + album.getNoTracks() +
                ") is not equal to the number of songs from the list attached (" +
                album.getSongs().size() + ")!");
    }
}
