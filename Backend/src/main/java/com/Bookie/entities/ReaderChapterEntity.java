package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity(name = "RaiderChapterEntity")
@Table(name = "reader_chapter")
@Data
@EqualsAndHashCode(of = "id")
public class ReaderChapterEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "reader_id", referencedColumnName = "id")
    @JsonIgnore
    private ReaderEntity reader;


    @ManyToOne
    @JoinColumn(name = "chapter_id", referencedColumnName = "id")
    @JsonIgnore
    private ChapterEntity chapter;

    private Boolean complete;

    public ReaderChapterEntity(ReaderEntity reader, ChapterEntity chapter) {
        this.chapter = chapter;
        this.reader = reader;
        this.complete = false;
    }
}
