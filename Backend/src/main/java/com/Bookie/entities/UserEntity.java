package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@Builder
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
    @JsonIgnore
    @OneToMany(mappedBy = "creator", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<HistoryEntity> histories = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<WishlistEntity> wishlishistory = new ArrayList<>();



   @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "wishlist",
            joinColumns = @JoinColumn(name = "id_user_entity"),
            inverseJoinColumns = @JoinColumn(name = "id_history")
    )
    private List<HistoryEntity> wishlist = new ArrayList<>();


    @OneToMany(mappedBy = "userId", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<ReaderEntity> raiderList = new ArrayList<>();

    @Override
    public String toString() {
        return "UserEntity{id=" + id + ", name='" + name + "', email='" + email + "', auth0UserId='" + auth0UserId + "'}";
    }
}