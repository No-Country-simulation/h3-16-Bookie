package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity(name ="WishlistEntity")
@Table(name = "wishlist")
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class WishlistEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_user_entity",  referencedColumnName = "id")
    @JsonIgnore
    private UserEntity user;
    @ManyToOne
    @JoinColumn(name = "id_history",  referencedColumnName = "id")
    @JsonIgnore
    private HistoryEntity history;


}
