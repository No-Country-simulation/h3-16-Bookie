package com.Bookie.entities;

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
    @JoinColumn(name = "UserEntity_id")
    @JsonIgnore
    private UserEntity user;
    @ManyToOne
    @JoinColumn(name = "HistoryEntity_id")
    @JsonIgnore
    private HistoryEntity history;
}