package com.Bookie.entities;

import com.Bookie.enums.GenreLiterary;
import jakarta.persistence.*;
import lombok.*;

@Entity(name = "HistoryEntity")
@Table(name = "history")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class HistoryEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title")
    private String title;
    @Column(name = "syopsis")
    private String syopsis;
    @Column(name = "publish")
    private Boolean publish;
    @ManyToOne
    @JoinColumn(name = "UserEntity_id")
    private UserEntity creator;
    @Enumerated(EnumType.STRING)
    private GenreLiterary genre;
    @Column(name = "img", columnDefinition = "text", length = 1000)
    private String img;
}
