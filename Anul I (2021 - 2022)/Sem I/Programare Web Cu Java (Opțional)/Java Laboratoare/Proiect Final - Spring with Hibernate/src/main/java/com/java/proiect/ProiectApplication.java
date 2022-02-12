package com.java.proiect;

import com.java.proiect.model.*;
import com.java.proiect.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Arrays;

@SpringBootApplication
public class ProiectApplication implements CommandLineRunner {

    private final GroupRepository groupRepository;
    private final ArtistRepository artistRepository;
    private final AlbumRepository albumRepository;
    private final AlbumDetailsRepository albumDetailsRepository;
    private final SongRepository songRepository;
    private final GenreRepository genreRepository;

    @Autowired
    public ProiectApplication(GroupRepository groupRepository, ArtistRepository artistRepository, AlbumRepository albumRepository, AlbumDetailsRepository albumDetailsRepository, SongRepository songRepository, GenreRepository genreRepository) {
        this.groupRepository = groupRepository;
        this.artistRepository = artistRepository;
        this.albumRepository = albumRepository;
        this.albumDetailsRepository = albumDetailsRepository;
        this.songRepository = songRepository;
        this.genreRepository = genreRepository;
    }

    public static void main(String[] args) {
        SpringApplication.run(ProiectApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        Genre g1 = new Genre("Pop");
        Genre g2 = new Genre("Dance-Pop");
        Genre g3 = new Genre("Electro-Pop");
        Genre g4 = new Genre("Hyper-Pop");
        genreRepository.save(g1);
        genreRepository.save(g2);
        genreRepository.save(g3);
        genreRepository.save(g4);

        Song s1 = new Song("aenergy", "2m 27s", Languages.KOREAN);
        Song s2 = new Song("Savage", "3m 58s", Languages.KOREAN);
        Song s3 = new Song("I'll Make You Cry", "3m 34s", Languages.ENGLISH);
        Song s4 = new Song("YEPPI YEPPI", "3m 33s", Languages.KOREAN);
        Song s5 = new Song("ICONIC", "3m 11s", Languages.ENGLISH);
        Song s6 = new Song("Lucid Dream", "3m 30s", Languages.KOREAN);

        AlbumDetails ad1 = new AlbumDetails(10.50, 20);

        Album a1 = new Album("Savage", "2021", 6);

        Artist si1 = new Artist("Yu Ji", "Min", "Karina", "11-Apr-2000");
        Artist si2 = new Artist("Uchinaga", "Aeri", "Giselle", "30-Oct-2000");
        Artist si3 = new Artist("Jeong", "Kim Min ", "Winter", "01-Jan-2001");
        Artist si4 = new Artist("Yizhuo", "Ning", "Ningning", "23-Oct-2002");

        Group group1 = new Group("aespa", 4, "2020", "0");
        groupRepository.save(group1);
        si1.setGroup(group1);
        si2.setGroup(group1);
        si3.setGroup(group1);
        si4.setGroup(group1);
        artistRepository.save(si1);
        artistRepository.save(si2);
        artistRepository.save(si3);
        artistRepository.save(si4);
        albumDetailsRepository.save(ad1);
        a1.setGroup(group1);
        a1.setAlbumDetails(ad1);
        albumRepository.save(a1);
        s1.setAlbum(a1);
        s2.setAlbum(a1);
        s3.setAlbum(a1);
        s4.setAlbum(a1);
        s5.setAlbum(a1);
        s6.setAlbum(a1);
        s1.setGenres(Arrays.asList(g1, g2));
        s2.setGenres(Arrays.asList(g1, g3));
        s3.setGenres(Arrays.asList(g1, g4));
        s4.setGenres(Arrays.asList(g1, g2, g3));
        s5.setGenres(Arrays.asList(g1));
        s6.setGenres(Arrays.asList(g1, g2, g4));
        songRepository.save(s1);
        songRepository.save(s2);
        songRepository.save(s3);
        songRepository.save(s4);
        songRepository.save(s5);
        songRepository.save(s6);
    }

}
