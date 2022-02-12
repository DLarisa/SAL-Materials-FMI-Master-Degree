package com.java.proiect.controller;

import com.java.proiect.model.Album;
import com.java.proiect.service.AlbumService;
import com.java.proiect.service.ShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/shop")
public class ShopController {
    private final ShopService shopService;
    private final AlbumService albumService;

    @Autowired
    public ShopController(ShopService shopService, AlbumService albumService) {
        this.shopService = shopService;
        this.albumService = albumService;
    }


    // Buy an Album
    @PostMapping("/{albumId}")
    public ResponseEntity<?> buyAlbum(@PathVariable int albumId,
                                      @RequestParam String no,
                                      @RequestParam(required = false) String country) {
        Album album = albumService.buyAlbum(albumId, no, country);
        return ResponseEntity.ok(album);
    }
}
