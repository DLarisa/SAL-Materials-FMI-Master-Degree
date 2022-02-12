package com.java.proiect.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import javax.validation.constraints.Pattern;

import static com.java.proiect.model.Patterns.DATE_OF_BIRTH;

@Entity
@Table(name = "artists")
public class Artist {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "artist_id")
    private int artistId;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Column(name = "stage_name", nullable = false, unique = true)
    private String stageName;

    @Column(name = "date_birth", nullable = false)
    @Pattern(regexp = DATE_OF_BIRTH, message = "The format must be dd-mmm-yyyy, with year between 1970-2099!")
    private String dateBirth;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "group_id")
    private Group group;



    public Artist() {
    }

    public Artist(int artistId, String firstName, String lastName, String stageName, String dateBirth) {
        this.artistId = artistId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.stageName = stageName;
        this.dateBirth = dateBirth;
    }

    public Artist(int artistId, String firstName, String lastName, String stageName, String dateBirth, Group group) {
        this.artistId = artistId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.stageName = stageName;
        this.dateBirth = dateBirth;
        this.group = group;
    }

    public Artist(String firstName, String lastName, String stageName, String dateBirth) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.stageName = stageName;
        this.dateBirth = dateBirth;
    }

    public Artist(String firstName, String lastName, String stageName, String dateBirth, Group group) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.stageName = stageName;
        this.dateBirth = dateBirth;
        this.group = group;
    }

    public Artist(int artistId, Group group) {
        this.artistId = artistId;
        this.group = group;
    }

    public int getArtistId() {
        return artistId;
    }

    public void setArtistId(int artistId) {
        this.artistId = artistId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public String getDateBirth() {
        return dateBirth;
    }

    public void setDateBirth(String dateBirth) {
        this.dateBirth = dateBirth;
    }

    public Group getGroup() {
        return group;
    }

    public void setGroup(Group group) {
        this.group = group;
    }
}
