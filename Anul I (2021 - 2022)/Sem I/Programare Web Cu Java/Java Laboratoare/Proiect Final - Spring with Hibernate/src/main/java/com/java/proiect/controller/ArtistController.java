package com.java.proiect.controller;

import com.java.proiect.dto.ArtistDtoForGroup;
import com.java.proiect.dto.UpdateArtistDto;
import com.java.proiect.exceptions.InvalidRequestUnmatchedId;
import com.java.proiect.mapper.ArtistMapper;
import com.java.proiect.model.Artist;
import com.java.proiect.service.ArtistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;

@RestController
@RequestMapping("/artist")
@Validated
public class ArtistController {
    private final ArtistService artistService;
    private final ArtistMapper artistMapper;

    @Autowired
    public ArtistController(ArtistService artistService, ArtistMapper artistMapper) {
        this.artistService = artistService;
        this.artistMapper = artistMapper;
    }



    // Add a New Artist (initially, if you add an artist, you cannot also assign the group)
    @PostMapping
    public ResponseEntity<?> add(@Valid
                                 @RequestBody ArtistDtoForGroup request) {
        Artist artist = artistService.add(artistMapper.createArtistDtoToArtist(request));
        return ResponseEntity.created(URI.create("/artist/" + artist.getArtistId())).body(artist);
    }

    // Update Artist (except GroupId)
    @PutMapping("/{id}/update")
    public ResponseEntity<?> update(@PathVariable int id,
                                    @Valid
                                    @RequestBody UpdateArtistDto request) {
        if(id != request.getId()) {
            throw new InvalidRequestUnmatchedId();
        }
        Artist artist = artistService.update(artistMapper.updateArtistDto(request));
        return ResponseEntity.ok(artist);
    }

    // Put Artist in Group
    @PutMapping("/{id}/putGroup/{groupId}")
    public ResponseEntity<?> updateGroup(@PathVariable int id, @PathVariable int groupId) {
        Artist artist = artistService.putGroup(id, groupId);
        return ResponseEntity.ok(artist);
    }

    // Delete an Artist
    @DeleteMapping("/{id}/delete")
    public ResponseEntity<?> delete(@PathVariable int id) {
        Artist artist = artistService.delete(id);
        return ResponseEntity.ok(artist);
    }

    // List all artists
    @GetMapping
    public ResponseEntity<?> get() {
        return ResponseEntity.ok().body(artistService.get());
    }
}
