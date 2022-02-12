package com.java.proiect.mapper;

import com.java.proiect.dto.SongDtoForAlbum;
import com.java.proiect.model.Song;
import org.springframework.stereotype.Component;

@Component
public class SongMapper {
    public Song createSongDtoToSongFromAlbum(SongDtoForAlbum request) {
        return new Song(request.getTitle(), request.getLength(), request.getLanguage());
    }
}
