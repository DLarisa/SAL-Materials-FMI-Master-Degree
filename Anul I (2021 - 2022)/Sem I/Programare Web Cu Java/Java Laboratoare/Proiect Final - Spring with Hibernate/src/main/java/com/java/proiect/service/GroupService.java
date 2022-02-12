package com.java.proiect.service;

import com.java.proiect.exceptions.*;
import com.java.proiect.model.Artist;
import com.java.proiect.model.Group;
import com.java.proiect.repository.ArtistRepository;
import com.java.proiect.repository.GroupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class GroupService {
    private final GroupRepository groupRepository;
    private final ArtistRepository artistRepository;

    @Autowired
    public GroupService(GroupRepository groupRepository, ArtistRepository artistRepository) {
        this.groupRepository = groupRepository;
        this.artistRepository = artistRepository;
    }

    // Add a New Group
    public Group add(Group group) {
        checkUniqueName(group);
        if(!group.getArtists().isEmpty()) {
            if(group.getNoMembers() != group.getArtists().size()) {
                throw new NoMembersNotEqualError(group);
            }
            checkUniqueStageName(group);
        }
        groupRepository.save(group);
        // Set the artists group
        for (Artist artist: group.getArtists()) {
            Artist a = artistRepository.getOne(artist.getArtistId());
            a.setGroup(group);
            artistRepository.save(a);
        }
        return group;
    }

    private void checkUniqueName(Group group) {
        Optional<Group> foundGroup = groupRepository.findByName(group.getName());
        if(foundGroup.isPresent()) {
            throw new DuplicateGroupError(group);
        }
    }

    private void checkUniqueStageName(Group group) {
        for (Artist artist: group.getArtists()) {
            if(!artistRepository.findByStageName(artist.getStageName()).isEmpty()) {
                throw new DuplicateArtistStageNameError(artist);
            }
        }
    }

    // Update Name / Year Debut / Year Disbandment
    public Group update(Group group) {
        Group foundGroup = groupRepository.findById(group.getGroupId()).orElseThrow(
                () -> new GroupNotFoundError(group)
        );
        if(!group.getName().equals(foundGroup.getName())) {
            checkUniqueName(group);
        }
        // To not ruin the no of members
        Group g = new Group(group.getGroupId(), group.getName(),
                foundGroup.getNoMembers(), group.getYearDebut(),
                group.getYearDisbandment());
        return groupRepository.save(g);
    }

    // Update Artists + No Members (Complete -> Delete Previous Ones and Put New Ones)
    public Group updateArtists(Group group) {
        Group foundGroup = groupRepository.findById(group.getGroupId()).orElseThrow(
                () -> new GroupNotFoundError(group)
        );
        if(group.getNoMembers() != group.getArtists().size()) {
            throw new NoMembersNotEqualError(group);
        }
        checkUniqueStageName(group);
        // To maintain the data from the found group
        Group g = new Group(group.getGroupId(), foundGroup.getName(),
                group.getNoMembers(), foundGroup.getYearDebut(),
                foundGroup.getYearDisbandment(), group.getArtists());
        groupRepository.save(g);

        // Set the artists group and delete the previous ones
        for (Artist artist: foundGroup.getArtists()) {
            artist.setGroup(null);
            artistRepository.save(artist);
        }
        for (Artist artist: g.getArtists()) {
            Optional<Artist> a = artistRepository.findByStageName(artist.getStageName());
            if(a.isPresent()) a.get().setGroup(g);
            artistRepository.save(a.get());
        }
        return g;
    }

    // Add a new artist to group
    public Group addArtist(int id, Artist artist) {
        Optional<Group> foundGroup = groupRepository.findById(id);
        if(foundGroup.isEmpty()) {
            throw new GroupNotFoundError();
        }
        if(artistRepository.findByStageName(artist.getStageName()).isPresent()) {
            throw new DuplicateArtistStageNameError(artist);
        }
        Group group = foundGroup.get();
        // Set group of artist
        artist.setGroup(group);
        artistRepository.save(artist);
        // Set group -> +1 for noMembers and added artist to the list
        group.setNoMembers(group.getNoMembers() + 1);
        List<Artist> artists = group.getArtists();
        artists.add(artist);
        group.setArtists(artists);
        return groupRepository.save(group);
    }

    // Add an existing artist to a group
    public Group putArtist(int id, int artistId) {
        // check group existence
        Optional<Group> foundGroup = groupRepository.findById(id);
        if(foundGroup.isEmpty()) {
            throw new GroupNotFoundError();
        }
        // check artist existence
        Optional<Artist> foundArtist = artistRepository.findById(artistId);
        if(foundArtist.isEmpty()) {
            throw new ArtistNotFoundError();
        }
        // delete artist from previous group (if exists)
        Artist artist = foundArtist.get();
        if(artist.getGroup() != null) {
            Group previousGroup = artist.getGroup();
            // artist already in the group
            if(previousGroup.getGroupId() == id) {
                throw new ArtistAlreadyInGroupError();
            }
            List<Artist> artists = previousGroup.getArtists();
            previousGroup.setNoMembers(previousGroup.getNoMembers() - 1);
            artists.remove(artist);
            previousGroup.setArtists(artists);
            artist.setGroup(null);
            groupRepository.save(previousGroup);
        }
        // put artist in group
        Group group = foundGroup.get();
        group.setNoMembers(group.getNoMembers() + 1);
        List<Artist> artistList = group.getArtists();
        artistList.add(artist);
        group.setArtists(artistList);
        groupRepository.save(group);
        artist.setGroup(group);
        artistRepository.save(artist);
        return group;
    }

    // Delete an artist from a group
    public Group deleteArtist(int id, int artistId) {
        // Not found group
        Optional<Group> foundGroup = groupRepository.findById(id);
        if(foundGroup.isEmpty()) {
            throw new GroupNotFoundError();
        }
        // Not found artist
        Optional<Artist> foundArtist = artistRepository.findById(artistId);
        if(foundArtist.isEmpty()) {
            throw new ArtistNotFoundError();
        }
        // Artist is not from the group provided
        if(foundArtist.get().getGroup() == null
                || foundArtist.get().getGroup().getGroupId() != id) {
            throw new InvalidRequestUnmatchedId(id);
        }
        Artist artist = foundArtist.get();
        // Artist is not in the group any-longer
        artist.setGroup(null);
        artistRepository.save(artist);
        // delete artist from group
        Group group = foundGroup.get();
        group.setNoMembers(group.getNoMembers() - 1);
        List<Artist> artists = group.getArtists();
        artists.remove(artist);
        group.setArtists(artists);
        return groupRepository.save(group);
    }

    // Get groups
    public Object get(String  noMembers, String year) {
        if(noMembers != null) {
            if(year != null) {
                return groupRepository.findByNoMembersAndYear(Integer.valueOf(noMembers), year);
            }
            return groupRepository.findByNoMembers(Integer.valueOf(noMembers));
        }
        if(year != null) {
            return groupRepository.findByYear(year);
        }
        return groupRepository.findAll();
    }
}
