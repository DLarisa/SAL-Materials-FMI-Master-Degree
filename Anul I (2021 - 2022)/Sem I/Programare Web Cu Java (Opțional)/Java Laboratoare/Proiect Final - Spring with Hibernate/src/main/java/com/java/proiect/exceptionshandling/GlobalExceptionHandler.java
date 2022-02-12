package com.java.proiect.exceptionshandling;

import com.java.proiect.exceptions.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler({DuplicateGroupError.class,
            NoMembersNotEqualError.class,
            DuplicateArtistStageNameError.class,
            InvalidRequestUnmatchedId.class,
            GroupNotFoundError.class,
            ArtistNotFoundError.class,
            ArtistAlreadyInGroupError.class,
            AlbumDetailsNotFoundError.class,
            PriceOrQuantityNegativeError.class,
            DuplicateAlbumError.class,
            NoTracksNotEqualError.class,
            NotAvailableLanguageType.class,
            AlbumNotFoundError.class,
            SongNotFoundError.class,
            SongAlreadyInAlbumError.class,
            DuplicateGenreError.class,
            NoSongsWithThisGenreError.class,
            NotInStockError.class,
            NotEnoughMoneyError.class})
    public ResponseEntity handle(Exception e) {
        return ResponseEntity.badRequest().body(e.getMessage());
    }
}
