package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity(name = "ReaderEntity")
@Table(name = "reader")
@Builder
@Data
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
    private UserEntity UserId;
    @ManyToOne
    @JoinColumn(name = "history_id",  referencedColumnName = "id")
    @JsonIgnore
    private HistoryEntity historyId;

    private Boolean complete;

}
