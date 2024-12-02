package com.Bookie.entities;

import com.Bookie.config.repository.UserRepository;
import com.Bookie.config.repository.WishlistRepositoty;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity(name ="Wishlist")
@Table(name = "wishlist")
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class WishlistEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_user_entity",  referencedColumnName = "id")
    @JsonIgnore
    private UserEntity user;
    @ManyToOne
    @JoinColumn(name = "id_history",  referencedColumnName = "id")
    @JsonIgnore
    private HistoryEntity history;

    public WishlistEntity(UserEntity userRepository, HistoryEntity history) {
        this.user = userRepository;
        this.history = history;
    }
}
