package com.java.proiect.model;

import com.java.proiect.dto.ArtistDtoForGroup;
import com.java.proiect.mapper.ArtistMapper;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "groups_musicians")
public class Group {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "group_id")
    private int groupId;

    @Column(unique = true, nullable = false)
    private String name;

    @Column(name = "no_members", nullable = false)
    private int noMembers;

    @Column(name = "year_debut", nullable = false)
    private String yearDebut;

    @Column(name = "year_disbandment")
    private String yearDisbandment;

    @OneToMany(mappedBy = "group", cascade = CascadeType.ALL)
    private List<Artist> artists = new ArrayList<>();

    @OneToMany(mappedBy = "group")
    private List<Album> albums = new ArrayList<>();



    public Group() {
    }

    public Group(int groupId, String name, int noMembers, String yearDebut, String yearDisbandment) {
        this.groupId = groupId;
        this.name = name;
        this.noMembers = noMembers;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
    }

    public Group(int groupId, String name, int noMembers, String yearDebut, String yearDisbandment, List<Artist> artists, List<Album> albums) {
        this.groupId = groupId;
        this.name = name;
        this.noMembers = noMembers;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
        this.artists = artists;
        this.albums = albums;
    }

    public Group(String name, int noMembers, String yearDebut, String yearDisbandment) {
        this.name = name;
        this.noMembers = noMembers;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
    }

    public Group(String name, int noMembers, String yearDebut, String yearDisbandment, List<ArtistDtoForGroup> artists) {
        this.name = name;
        this.noMembers = noMembers;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
        ArtistMapper artistMapper = new ArtistMapper();
        List<Artist> artists1 = new ArrayList<>();
        for (ArtistDtoForGroup a: artists) {
            artists1.add(artistMapper.createArtistDtoToArtist(a));
        }
        this.artists = artists1;
    }

    public Group(String name, String yearDebut, String yearDisbandment) {
        this.name = name;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
    }

    public Group(int id, String name, String yearDebut, String yearDisbandment) {
        this.groupId = id;
        this.name = name;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
    }

    public Group(int id, int noMembers, List<ArtistDtoForGroup> artists) {
        this.groupId = id;
        this.noMembers = noMembers;
        ArtistMapper artistMapper = new ArtistMapper();
        List<Artist> artists1 = new ArrayList<>();
        for (ArtistDtoForGroup a: artists) {
            artists1.add(artistMapper.createArtistDtoToArtist(a));
        }
        this.artists = artists1;
    }

    public Group(int groupId, String name, int noMembers, String yearDebut, String yearDisbandment, List<Artist> artists) {
        this.groupId = groupId;
        this.name = name;
        this.noMembers = noMembers;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
        this.artists = artists;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getNoMembers() {
        return noMembers;
    }

    public void setNoMembers(int noMembers) {
        this.noMembers = noMembers;
    }

    public String getYearDebut() {
        return yearDebut;
    }

    public void setYearDebut(String yearDebut) {
        this.yearDebut = yearDebut;
    }

    public String getYearDisbandment() {
        return yearDisbandment;
    }

    public void setYearDisbandment(String yearDisbandment) {
        this.yearDisbandment = yearDisbandment;
    }

    public List<Artist> getArtists() {
        return artists;
    }

    public void setArtists(List<Artist> artists) {
        this.artists = artists;
    }

    public List<Album> getAlbums() {
        return albums;
    }

    public void setAlbums(List<Album> albums) {
        this.albums = albums;
    }
}
