package com.java.proiect.service;

import com.java.proiect.exceptions.ArtistAlreadyInGroupError;
import com.java.proiect.exceptions.ArtistNotFoundError;
import com.java.proiect.exceptions.DuplicateArtistStageNameError;
import com.java.proiect.exceptions.GroupNotFoundError;
import com.java.proiect.model.Artist;
import com.java.proiect.model.Group;
import com.java.proiect.repository.ArtistRepository;
import com.java.proiect.repository.GroupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ArtistService {
    private final ArtistRepository artistRepository;
    private final GroupRepository groupRepository;

    @Autowired
    public ArtistService(ArtistRepository artistRepository, GroupRepository groupRepository) {
        this.artistRepository = artistRepository;
        this.groupRepository = groupRepository;
    }

    // Add a New Artist
    public Artist add(Artist artist) {
        checkUniqueStageName(artist);
        return artistRepository.save(artist);
    }

    private void checkUniqueStageName(Artist artist) {
        Optional<Artist> foundArtist = artistRepository.findByStageName(artist.getStageName());
        if(foundArtist.isPresent()) {
            throw new DuplicateArtistStageNameError(artist);
        }
    }

    // Update Artist (except group)
    public Artist update(Artist artist) {
        Artist foundArtist = artistRepository.findById(artist.getArtistId()).orElseThrow(
                () -> new ArtistNotFoundError()
        );
        if(!artist.getStageName().equals(foundArtist.getStageName())) {
            checkUniqueStageName(artist);
        }
        // To not ruin the artist when updated in the db
        Artist a = new Artist(artist.getArtistId(), artist.getFirstName(), artist.getLastName(),
                foundArtist.getStageName(), artist.getDateBirth(), foundArtist.getGroup());
        return artistRepository.save(a);
    }

    // Put Artist in Group
    public Artist putGroup(int id, int groupId) {
        // check group existence
        Optional<Group> foundGroup = groupRepository.findById(groupId);
        if(foundGroup.isEmpty()) {
            throw new GroupNotFoundError();
        }
        // check artist existence
        Optional<Artist> foundArtist = artistRepository.findById(id);
        if(foundArtist.isEmpty()) {
            throw new ArtistNotFoundError();
        }
        // Delete artist from previous group (if exists)
        Artist artist = foundArtist.get();
        if(artist.getGroup() != null) {
            Group groupOld = artist.getGroup();
            // artist already in the group
            if(groupOld.getGroupId() == groupId) {
                throw new ArtistAlreadyInGroupError();
            }
            List<Artist> artists = groupOld.getArtists();
            groupOld.setNoMembers(groupOld.getNoMembers() - 1);
            artists.remove(foundArtist);
            groupOld.setArtists(artists);
            artist.setGroup(null);
            groupRepository.save(groupOld);
        }
        Group group = foundGroup.get();
        group.setNoMembers(group.getNoMembers() + 1);
        List<Artist> artists = group.getArtists();
        artists.add(artist);
        group.setArtists(artists);
        groupRepository.save(group);
        artist.setGroup(group);
        artistRepository.save(artist);
        return artist;
    }

    // Delete artist (also from group)
    public Artist delete(int id) {
        Artist artist = artistRepository.findById(id).orElseThrow(
                () -> new ArtistNotFoundError()
        );
        Group group = artist.getGroup();
        group.setNoMembers(group.getNoMembers() - 1);
        groupRepository.save(group);
        artistRepository.delete(artist);
        return artist;
    }

    // Get all artist
    public List<Artist> get() {
        return artistRepository.findAll();
    }
}
