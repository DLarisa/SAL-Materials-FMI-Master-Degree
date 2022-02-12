package com.java.proiect.service;

import com.java.proiect.exceptions.AlbumDetailsNotFoundError;
import com.java.proiect.model.AlbumDetails;
import com.java.proiect.repository.AlbumDetailsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AlbumDetailsService {
    private final AlbumDetailsRepository albumDetailsRepository;

    @Autowired
    public AlbumDetailsService(AlbumDetailsRepository albumDetailsRepository) {
        this.albumDetailsRepository = albumDetailsRepository;
    }


    // Update Album Details
    public AlbumDetails update(AlbumDetails request) {
        AlbumDetails albumDetailsFound = albumDetailsRepository.findById(request.getAlbumDetailsId()).
                orElseThrow(()->{throw new AlbumDetailsNotFoundError();});
        return albumDetailsRepository.save(request);
    }

//    @Lazy
//    public AlbumDetails convertMoney(int ok, AlbumDetails request) {
//        AlbumDetails albumDetailsFound = albumDetailsRepository.findById(request.getAlbumDetailsId()).
//                orElseThrow(()->{throw new AlbumDetailsNotFoundError();});
//        if(ok == 1) {
//            double newPrice = albumDetailsFound.getPrice() * 5;
//            albumDetailsFound.setPrice(newPrice);
//        }
//        return albumDetailsRepository.save(albumDetailsFound);
//    }
}
