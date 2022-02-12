package com.java.proiect.mapper;

import com.java.proiect.dto.ArtistDtoForGroup;
import com.java.proiect.dto.UpdateArtistDto;
import com.java.proiect.model.Artist;
import org.springframework.stereotype.Component;

@Component
public class ArtistMapper {
    public Artist createArtistDtoToArtist(ArtistDtoForGroup artistDtoForGroup) {
        return new Artist(artistDtoForGroup.getFirstName(), artistDtoForGroup.getLastName(),
                artistDtoForGroup.getStageName(), artistDtoForGroup.getDateBirth());
    }

    public Artist updateArtistDto(UpdateArtistDto request) {
        return new Artist(request.getId(), request.getFirstName(),
                request.getLastName(), request.getStageName(), request.getDateBirth());
    }
}
