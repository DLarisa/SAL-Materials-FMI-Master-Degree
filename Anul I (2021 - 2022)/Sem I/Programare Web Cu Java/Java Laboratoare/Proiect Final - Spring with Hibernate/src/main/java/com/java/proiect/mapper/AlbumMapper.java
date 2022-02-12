package com.java.proiect.mapper;

import com.java.proiect.dto.CreateAlbumDto;
import com.java.proiect.dto.UpdateAlbumDtoSimple;
import com.java.proiect.exceptions.GroupNotFoundError;
import com.java.proiect.model.Album;
import com.java.proiect.model.Group;
import com.java.proiect.repository.GroupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class AlbumMapper {
    private final GroupRepository groupRepository;

    @Autowired
    public AlbumMapper(GroupRepository groupRepository) {
        this.groupRepository = groupRepository;
    }


    public Album addAlbumDto(CreateAlbumDto request) {
        // verify if group exists, otherwise we cannot add the album
        if(groupRepository.findByName(request.getGroupName()).isEmpty()) {
            throw new GroupNotFoundError();
        }

        Group group = groupRepository.findByName(request.getGroupName()).get();
        if(request.getSongs() != null) {
            return new Album(request.getTitle(), request.getYear(),
                    request.getNoTracks(), group, request.getAlbumDetails(),
                    request.getSongs());
        }
        return new Album(request.getTitle(), request.getYear(),
                request.getNoTracks(), group, request.getAlbumDetails());
    }

    public Album updateAlbumDtoToAlbum(UpdateAlbumDtoSimple request) {
        return new Album(request.getId(), request.getTitle(), request.getYear(), request.getNoTracks());
    }
}
