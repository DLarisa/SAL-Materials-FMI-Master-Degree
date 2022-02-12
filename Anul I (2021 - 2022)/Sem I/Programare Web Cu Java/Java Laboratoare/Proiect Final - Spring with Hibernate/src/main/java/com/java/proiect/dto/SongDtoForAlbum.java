package com.java.proiect.dto;

import com.java.proiect.model.Languages;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import static com.java.proiect.model.Patterns.LENGTH;

public class SongDtoForAlbum {
    @NotBlank(message = "A song must have a title!")
    @Size(max = 300)
    private String title;

    @Pattern(regexp = LENGTH, message = "A song must have a length expressed as _h _m _s!")
    private String length;
    private Languages language;



    public SongDtoForAlbum() {
    }

    public SongDtoForAlbum(String title, String length, Languages language) {
        this.title = title;
        this.length = length;
        this.language = language;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public Languages getLanguage() {
        return language;
    }

    public void setLanguage(Languages language) {
        this.language = language;
    }
}
