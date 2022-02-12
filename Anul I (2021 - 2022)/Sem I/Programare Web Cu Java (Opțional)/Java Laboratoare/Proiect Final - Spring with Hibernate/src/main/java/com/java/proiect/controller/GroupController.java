package com.java.proiect.controller;

import com.java.proiect.dto.ArtistDtoForGroup;
import com.java.proiect.dto.CreateGroupDtoToGroup;
import com.java.proiect.dto.UpdateGroupDtoToGroupArtists;
import com.java.proiect.dto.UpdateGroupDtoToGroupSimple;
import com.java.proiect.exceptions.InvalidRequestUnmatchedId;
import com.java.proiect.mapper.ArtistMapper;
import com.java.proiect.mapper.GroupMapper;
import com.java.proiect.model.Group;
import com.java.proiect.service.GroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;

@RestController
@RequestMapping("/group")
@Validated
public class GroupController {
    private final GroupService groupService;
    private final GroupMapper groupMapper;

    @Autowired
    public GroupController(GroupService groupService, GroupMapper groupMapper) {
        this.groupService = groupService;
        this.groupMapper = groupMapper;
    }



    // Add a New Group
    @PostMapping
    public ResponseEntity<?> add(@Valid
                                 @RequestBody CreateGroupDtoToGroup request) {
        Group group = groupService.add(groupMapper.addGroupDtoToGroup(request));
        return ResponseEntity.created(URI.create("/group/" + group.getGroupId())).body(group);
    }

    // Update Name / Year Debut / Year Disbandment
    @PutMapping("/{id}/update")
    public ResponseEntity<?> update(@PathVariable int id,
                                    @Valid
                                    @RequestBody UpdateGroupDtoToGroupSimple request) {
        if(id != request.getId()) {
            throw new InvalidRequestUnmatchedId();
        }
        Group group = groupService.update(groupMapper.updateGroupDtoToGroup(request));
        return ResponseEntity.ok(group);
    }

    // Update Artists
    @PutMapping("/{id}/update/artists")
    public ResponseEntity<?> updateArtists(@PathVariable int id,
                                           @Valid
                                           @RequestBody UpdateGroupDtoToGroupArtists request) {
        if(id != request.getId()) {
            throw new InvalidRequestUnmatchedId();
        }
        Group group = groupService.updateArtists(groupMapper.updateGroupDtoArtists(request));
        return ResponseEntity.ok(request);
    }

    // Add a new artist to a group
    @PutMapping("/{id}/addArtist")
    public ResponseEntity<?> addArtist(@PathVariable int id,
                                       @Valid
                                       @RequestBody ArtistDtoForGroup request) {
        ArtistMapper artistMapper = new ArtistMapper();
        Group group = groupService.addArtist(id, artistMapper.createArtistDtoToArtist(request));
        return ResponseEntity.ok(group);
    }

    // Add an existing artist to a group
    @PutMapping("/{id}/putArtist/{artistId}")
    public ResponseEntity<?> putArtist(@PathVariable int id, @PathVariable int artistId) {
        Group group = groupService.putArtist(id, artistId);
        return ResponseEntity.ok(group);
    }

    // Delete an artist from a group
    @PutMapping("/{id}/deleteArtist/{artistId}")
    public ResponseEntity<?> deleteArtist(@PathVariable int id, @PathVariable int artistId) {
        Group group = groupService.deleteArtist(id, artistId);
        return ResponseEntity.ok(group);
    }

    // Get groups based on no of members or year (can be either one) or all groups
    @GetMapping
    public ResponseEntity<?> get(@RequestParam(required = false) String noMembers,
                                 @RequestParam(required = false) String year) {
        return ResponseEntity.ok().body(groupService.get(noMembers, year));
    }
}
