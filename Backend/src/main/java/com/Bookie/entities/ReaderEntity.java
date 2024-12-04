package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity(name = "ReaderEntity")
@Table(name = "reader")
@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class ReaderEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id",  referencedColumnName = "id")
    @JsonIgnore
    private UserEntity userId;
    @ManyToOne
    @JoinColumn(name = "history_id",  referencedColumnName = "id")
    @JsonIgnore
    private HistoryEntity historyId;

    private Boolean complete;


    @OneToMany(mappedBy = "reader",cascade = CascadeType.ALL,orphanRemoval = true,fetch = FetchType.LAZY)
    @JsonIgnore
    private List<ReaderChapterEntity> readerChapter;

    public ReaderEntity(UserEntity user, HistoryEntity history) {
        this.userId = user;
        this.historyId = history;
        this.complete = false;
    }

}
