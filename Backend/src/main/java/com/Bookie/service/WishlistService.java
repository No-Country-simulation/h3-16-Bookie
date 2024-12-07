package com.Bookie.service;

import com.Bookie.config.repository.HistoryRepository;
import com.Bookie.config.repository.UserRepository;
import com.Bookie.config.repository.WishlistRepositoty;
import com.Bookie.dto.ReaderRequest;
import com.Bookie.dto.WishlistByUser;
import com.Bookie.dto.WishlistRequestCreate;
import com.Bookie.dto.WishlistResponseCreate;
import com.Bookie.entities.ReaderEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.entities.WishlistEntity;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class WishlistService {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private WishlistRepositoty wishlistRepositoty;

    @Autowired
    private HistoryRepository historyRepository;

    public java.util.List<com.Bookie.entities.HistoryEntity> getWishlist(Long id) {
       return userService.getWishlist(id);
    }

    public WishlistResponseCreate createHistory(WishlistRequestCreate wishlist) {



        var user = userRepository.findById(wishlist.userID()).orElseThrow( ()-> new EntityNotFoundException("User not found"));

        var history =historyRepository.findById(wishlist.historyID()).orElseThrow( ()-> new EntityNotFoundException("History not found"));



        //verificar si ya existe
        WishlistEntity wishlistDb = wishlistRepositoty.findByUserAndHistory(user, history);
        if (wishlistDb != null) return new WishlistResponseCreate(wishlistDb);

        WishlistEntity wishlistDB = new WishlistEntity();
        wishlistDB.setHistory(history);
        wishlistDB.setUser(user);

         wishlistDB = wishlistRepositoty.save(wishlistDB);
        return new WishlistResponseCreate(wishlistDB);
    }

    public void deleteWishlist(Long id) {
        var whislint = wishlistRepositoty.findById(id).orElseThrow(()-> new EntityNotFoundException("whislist not found"));
        wishlistRepositoty.delete(whislint);
    }

    public List<WishlistByUser> getWishlistByUserId(Long id) {
        UserEntity user = userRepository.findById(id).orElseThrow( ()-> new EntityNotFoundException("User not found"));
        List<WishlistEntity> wishlist = user.getWishlishistory();
        if(wishlist.isEmpty()) return new ArrayList<>();
        List<WishlistByUser> wishlistByUsers = wishlist.stream().map(WishlistByUser::new).toList();
        return wishlistByUsers;

    }
}
