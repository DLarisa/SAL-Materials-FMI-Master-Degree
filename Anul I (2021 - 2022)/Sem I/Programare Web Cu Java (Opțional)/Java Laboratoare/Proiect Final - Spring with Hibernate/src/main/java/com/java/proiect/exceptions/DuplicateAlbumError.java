package com.java.proiect.exceptions;

import com.java.proiect.model.Album;

public class DuplicateAlbumError extends RuntimeException{
    public DuplicateAlbumError(Album album) {
        super("There is already an album with the title \"" + album.getTitle() +
                "\" in the group " + album.getGroup().getName());
    }

    public DuplicateAlbumError(String title, Album foundAlbum) {
        super("There is already an album with the title \"" + title +
                "\" in the group " + foundAlbum.getGroup().getName());
    }
}
