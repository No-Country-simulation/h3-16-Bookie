package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(unique = true, nullable = false)
    private String email;


    private String auth0UserId;

    @OneToMany(mappedBy = "creator", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<HistoryEntity> histories = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<WishlistEntity> wishlishistory;


    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "wishlist",
            joinColumns = @JoinColumn(name = "id_UserEntity"),
            inverseJoinColumns = @JoinColumn(name = "id_history")
    )
    private List<HistoryEntity> wishlist;

    @Override
    public String toString() {
        return "UserEntity{id=" + id + ", name='" + name + "', email='" + email + "', auth0UserId='" + auth0UserId + "'}";
    }
}