package com.java.proiect.controller;

import com.java.proiect.dto.CreateAlbumDto;
import com.java.proiect.dto.SongDtoForAlbum;
import com.java.proiect.dto.UpdateAlbumDtoSimple;
import com.java.proiect.exceptions.InvalidRequestUnmatchedId;
import com.java.proiect.mapper.AlbumMapper;
import com.java.proiect.mapper.SongMapper;
import com.java.proiect.model.Album;
import com.java.proiect.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;

@RestController
@RequestMapping("/album")
@Validated
public class AlbumController {
    private final AlbumService albumService;
    private final AlbumMapper albumMapper;

    @Autowired
    public AlbumController(AlbumService albumService, AlbumMapper albumMapper) {
        this.albumService = albumService;
        this.albumMapper = albumMapper;
    }



    // Add a New Album (We add the Details with it always and it must belong to an existing group from the database)
    @PostMapping
    public ResponseEntity<?> add(@Valid
                                 @RequestBody CreateAlbumDto request) {
        Album album = albumService.add(albumMapper.addAlbumDto(request));
        return ResponseEntity.created(URI.create("/album/" + album.getAlbumId())).body(album);
    }

    // Update Title / Year
    @PutMapping("/{id}/update")
    public ResponseEntity<?> update(@PathVariable int id,
                                    @Valid
                                    @RequestBody UpdateAlbumDtoSimple request) {
        if(id != request.getId()) {
            throw new InvalidRequestUnmatchedId();
        }
        Album album = albumService.update(albumMapper.updateAlbumDtoToAlbum(request));
        return ResponseEntity.ok(album);
    }

    // Add New Song to Album
    @PutMapping("/{id}/addSong")
    public ResponseEntity<?> updateSongs(@PathVariable int id,
                                         @Valid
                                         @RequestBody SongDtoForAlbum request) {
        SongMapper songMapper = new SongMapper();
        Album album = albumService.addSong(id, songMapper.createSongDtoToSongFromAlbum(request));
        return ResponseEntity.ok(album);
    }

    // Add an existing song to the album
    @PutMapping("/{id}/putSong/{songId}")
    public ResponseEntity<?> putSong(@PathVariable int id, @PathVariable int songId) {
        Album album = albumService.putSong(id, songId);
        return ResponseEntity.ok(album);
    }

    // Delete a song from the album
    @PutMapping("/{id}/deleteSong/{songId}")
    public ResponseEntity<?> deleteSong(@PathVariable int id, @PathVariable int songId) {
        Album album = albumService.deleteSong(id, songId);
        return ResponseEntity.ok(album);
    }

    // List all albums based on Year or Price or all
    @GetMapping
    public ResponseEntity<?> get(@RequestParam(required = false) String year,
                                 @RequestParam(required = false) String price) {
        return ResponseEntity.ok().body(albumService.get(year, price));
    }
}
