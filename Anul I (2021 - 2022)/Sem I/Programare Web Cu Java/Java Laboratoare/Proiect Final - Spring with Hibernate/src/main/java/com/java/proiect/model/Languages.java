package com.java.proiect.model;

public enum Languages {
    KOREAN, ENGLISH, JAPANESE, CHINESE, SPANISH;

    static public boolean isMember(String language) {
        Languages[] languages = Languages.values();
        for(Languages l: languages) {
            if(l.equals(language))
                return true;
        }
        return false;
    }
}
