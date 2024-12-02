package com.Bookie.service;

import com.Bookie.config.repository.HistoryRepository;
import com.Bookie.config.repository.UserRepository;
import com.Bookie.config.repository.WishlistRepositoty;
import com.Bookie.dto.WishlistRequestCreate;
import com.Bookie.dto.WishlistResponseCreate;
import com.Bookie.entities.WishlistEntity;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

        WishlistEntity wishlistDB = new WishlistEntity();
        wishlistDB.setHistory(history);
        wishlistDB.setUser(user);

         wishlistDB = wishlistRepositoty.save(wishlistDB);
        return new WishlistResponseCreate(wishlistDB);
    }
}
