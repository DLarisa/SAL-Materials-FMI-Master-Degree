package com.java.proiect.service;

import com.java.proiect.exceptions.*;
import com.java.proiect.model.Album;
import com.java.proiect.model.AlbumDetails;
import com.java.proiect.model.MoneyConverter;
import com.java.proiect.model.Song;
import com.java.proiect.repository.AlbumDetailsRepository;
import com.java.proiect.repository.AlbumRepository;
import com.java.proiect.repository.SongRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final AlbumDetailsRepository albumDetailsRepository;
    private final SongRepository songRepository;

    @Autowired
    public AlbumService(AlbumRepository albumRepository, AlbumDetailsRepository albumDetailsRepository, SongRepository songRepository) {
        this.albumRepository = albumRepository;
        this.albumDetailsRepository = albumDetailsRepository;
        this.songRepository = songRepository;
    }



    // Add a New Album (We add the Details with it always and it must belong to an existing group from the database)
    public Album add(Album album) {
        Optional<Album> foundAlbum = albumRepository.findByTitleAndGroup(album.getTitle(), album.getGroup());
        if(foundAlbum.isPresent()) {
            throw new DuplicateAlbumError(album);
        }
        if(!album.getSongs().isEmpty()) {
            if(album.getNoTracks() != album.getSongs().size()) {
                throw new NoTracksNotEqualError(album);
            }
        }
        AlbumDetails albumDetails = album.getAlbumDetails();
        albumDetails.setAlbum(album);
        albumDetailsRepository.save(albumDetails);
        albumRepository.save(album);
        // Set the songs in album
        for (Song song: album.getSongs()) {
            Song s = songRepository.getById(song.getSongId());
            s.setAlbum(album);
            songRepository.save(s);
        }
        return album;
    }

    // Update Title / Year
    public Album update(Album album) {
        Album foundAlbum = albumRepository.findById(album.getAlbumId()).orElseThrow(
                () -> new AlbumNotFoundError()
        );
        if(!album.getTitle().equals(foundAlbum.getTitle())) {
            Optional<Album> albumExists = albumRepository.findByTitleAndGroup(album.getTitle(), foundAlbum.getGroup());
            if(albumExists.isPresent()) {
                throw new DuplicateAlbumError(album.getTitle(), foundAlbum);
            }
        }
        Album a = new Album(album.getAlbumId(), album.getTitle(),
                album.getYear(), foundAlbum.getNoTracks(), foundAlbum.getGroup(),
                foundAlbum.getAlbumDetails(), foundAlbum.getSongs());
        return albumRepository.save(a);
    }

    // Add New Song to Album
    public Album addSong(int id, Song song) {
        Optional<Album> foundAlbum = albumRepository.findById(id);
        if(foundAlbum.isEmpty()) {
            throw new AlbumNotFoundError();
        }
        Album album = foundAlbum.get();
        // Set album to song
        song.setAlbum(album);
        songRepository.save(song);
        // Set Album -> +1 noTracks and added song to list
        album.setNoTracks(album.getNoTracks() + 1);
        List<Song> songs = album.getSongs();
        songs.add(song);
        album.setSongs(songs);
        return albumRepository.save(album);
    }

    // Add an existing song to the album
    // The song can be from another album (we don't delete it) or it can not have an album
    public Album putSong(int id, int songId) {
        // check album existence
        Optional<Album> foundAlbum = albumRepository.findById(id);
        if(foundAlbum.isEmpty()) {
            throw new AlbumNotFoundError();
        }
        // check song existence
        Optional<Song> foundSong = songRepository.findById(songId);
        if(foundSong.isEmpty()) {
            throw new SongNotFoundError();
        }
        // put song in album
        Song song = foundSong.get();
        Album album = foundAlbum.get();
        album.setNoTracks(album.getNoTracks() + 1);
        List<Song> songList = album.getSongs();
        songList.add(song);
        album.setSongs(songList);
        albumRepository.save(album);
        song.setAlbum(album);
        songRepository.save(song);
        return album;
    }

    // Delete a song from the album
    public Album deleteSong(int id, int songId) {
        // Not found album
        Optional<Album> foundAlbum = albumRepository.findById(id);
        if(foundAlbum.isEmpty()) {
            throw new AlbumNotFoundError();
        }
        // Not found song
        Optional<Song> foundSong = songRepository.findById(songId);
        if(foundSong.isEmpty()) {
            throw new SongNotFoundError();
        }
        // Song is not from the album provided
        if(foundSong.get().getAlbum() == null
                || foundSong.get().getAlbum().getAlbumId() != id) {
            throw new InvalidRequestUnmatchedId(id);
        }
        Song song = foundSong.get();
        // Song is not in the album any-longer
        song.setAlbum(null);
        songRepository.save(song);
        // delete song from album
        Album album = foundAlbum.get();
        album.setNoTracks(album.getNoTracks() - 1);
        List<Song> songs = album.getSongs();
        songs.remove(song);
        album.setSongs(songs);
        return albumRepository.save(album);
    }

    // get albums
    public Object get(String year, String price) {
        if(year != null) return albumRepository.findByYear(year);
        if(price != null) return albumRepository.findByAlbumDetails_Price(Double.valueOf(price));
        return albumRepository.findAll();
    }

    // buy album (can convert money to get from bank account, reduce quantity of products)
    @Transactional
    public Album buyAlbum(int albumId, String no, String country) {
        // check if album exists
        Optional<Album> foundAlbum = albumRepository.findById(albumId);
        if(foundAlbum.isEmpty()) {
            throw new AlbumNotFoundError();
        }
        // check if album is still in stock and if the noOfCopied wanted by the buyer exists
        Album album = foundAlbum.get();
        if(album.getAlbumDetails().getQuantity() == 0 ||
            album.getAlbumDetails().getQuantity() < Integer.valueOf(no)) {
            throw new NotInStockError();
        }
        // teoretic aci e partea când iei informațiile din bancă, dar nu mai ai timp nici să mor... așa că presupunem că toată lumea e putred de bogată =)
        // hardcodăm și noi niște avere pe aci (banii din banca boierului care vrea să cumpere; depinde din ce țară e)
        double fortune = 30;
        MoneyConverter moneyConverter = new MoneyConverter();
        double price = album.getAlbumDetails().getPrice() * Integer.valueOf(no);
        if(country.equalsIgnoreCase("IT")) {
            price = moneyConverter.convertToEuros(price);
        }
        else if(country.equalsIgnoreCase("RO")) {
            price = moneyConverter.convertToRon(price);
        }
        else if(country.equalsIgnoreCase("KO")) {
            price = moneyConverter.convertToWon(price);
        }
        else {
            throw new NotEnoughMoneyError();
        }

        if(fortune < price) {
            throw new NotEnoughMoneyError();
        }
        fortune = fortune - price;
        System.out.println(fortune);

        int quantity = album.getAlbumDetails().getQuantity() - 1;
        AlbumDetails ad = album.getAlbumDetails();
        ad.setQuantity(quantity);
        albumDetailsRepository.save(ad);
        album.setAlbumDetails(ad);
        return albumRepository.save(album);
    }
}
