package com.capsule.youkids.festival.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "festival_reserve")
public class FestivalReserve {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long festivalReserveId;

    @Column
    private String date;

    @Column
    private String url;

    @Column
    private String festivalChildId;

    @Column
    private String site;
}
