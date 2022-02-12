package com.java.proiect.controller;

import com.java.proiect.exceptions.InvalidRequestUnmatchedId;
import com.java.proiect.model.AlbumDetails;
import com.java.proiect.service.AlbumDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/albumDetails")
@Validated
public class AlbumDetailsController {
    private final AlbumDetailsService albumDetailsService;

    @Autowired
    public AlbumDetailsController(AlbumDetailsService albumDetailsService) {
        this.albumDetailsService = albumDetailsService;
    }



    // Update Album Details (Only this because we add them with the album)
    // (We list them with the album & We delete them with the album)
    // (Operations are in shop)
    @PutMapping("/{id}/update")
    public ResponseEntity<?> update(@PathVariable int id,
                                    @Valid
                                    @RequestBody AlbumDetails request) {
        System.out.println(id);
        System.out.println(request.getAlbumDetailsId());
        if(id != request.getAlbumDetailsId()) {
            throw new InvalidRequestUnmatchedId();
        }
        return ResponseEntity.ok().body(albumDetailsService.update(request));
    }
}
