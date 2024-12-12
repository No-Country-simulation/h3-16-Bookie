package com.Bookie.entities;

import com.Bookie.enums.GenreLiterary;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import java.util.List;

@Entity(name = "HistoryEntity")
@Table(name = "history")
@Getter
@Setter
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
    private Boolean publish = false;
    @ManyToOne
    @JoinColumn(name = "user_entity_id")
    @JsonIgnore
    private UserEntity creator;
    @Enumerated(EnumType.STRING)
    @Column(name = "genre")
    private GenreLiterary genre;
    @Column(name = "img", columnDefinition = "text", length = 1000)
    private String img;
    @Column(name = "distance")
    private Double distance;

    @ManyToOne
    @JoinColumn(name = "province_entity_id", referencedColumnName = "id")
    @JsonIgnore
    private ProvinceEntity province;

    @OneToMany(mappedBy = "history", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<WishlistEntity> wishlishistory;

    @OneToMany(mappedBy = "history", cascade = CascadeType.ALL,orphanRemoval = true,fetch = FetchType.LAZY)
    private List<ChapterEntity> chapters;


    @OneToMany(mappedBy = "historyId", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<ReaderEntity> raider;



}
