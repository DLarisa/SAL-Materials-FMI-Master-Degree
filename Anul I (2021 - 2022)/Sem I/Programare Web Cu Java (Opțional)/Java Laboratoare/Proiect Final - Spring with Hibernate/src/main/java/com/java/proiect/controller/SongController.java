package com.java.proiect.controller;

import com.java.proiect.dto.SongDtoForAlbum;
import com.java.proiect.mapper.SongMapper;
import com.java.proiect.model.Genre;
import com.java.proiect.model.Song;
import com.java.proiect.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/song")
@Valid
public class SongController {
    private final SongService songService;
    private final SongMapper songMapper;

    @Autowired
    public SongController(SongService songService, SongMapper songMapper) {
        this.songService = songService;
        this.songMapper = songMapper;
    }



    // Add a New Song (no group, no genres)
    @PostMapping
    public ResponseEntity<?> add(@Valid
                                 @RequestBody SongDtoForAlbum request) {
        Song song = songService.add(songMapper.createSongDtoToSongFromAlbum(request));
        return ResponseEntity.created(URI.create("/song/" + song.getSongId())).body(song);
    }

    // Put Song in Album
    @PutMapping("/{id}/setAlbum/{albumId}")
    public ResponseEntity<?> setAlbum(@PathVariable int id, @PathVariable int albumId) {
        Song song = songService.setAlbum(id, albumId);
        return ResponseEntity.ok(song);
    }

    // Assign new genres for a Song
    @PutMapping("/{id}/setGenres")
    public ResponseEntity<?> setNewGenres(@PathVariable int id,
                                      @Valid
                                      @RequestBody List<Genre> genres) {
        Song song = songService.setGenres(id, genres);
        return ResponseEntity.ok(song);
    }

    // Assign existing genre for a Song
    @PutMapping("/{id}/setGenre/{genreId}")
    public ResponseEntity<?> setGenre(@PathVariable int id, @PathVariable int genreId) {
        Song song = songService.setGenre(id, genreId);
        return ResponseEntity.ok(song);
    }

    // Delete specific Genre from all Songs with that Genre
    @DeleteMapping("/delete/genre")
    public ResponseEntity<?> deleteSongsWithGenre(@RequestParam String type) {
        List<Song> songs = songService.deleteSongsWithGenre(type);
        return ResponseEntity.ok(songs);
    }

    // List All Songs in a Certain Language
    @GetMapping
    public List<Song> getSongsByLanguage(@RequestParam String language) {
        return songService.getSongsByLanguage(language);
    }
}
