package com.capsule.youkids.festival.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
public class FestivalImage {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int festivalImageId;

    @Column
    private String url;

    @ManyToOne
    @JoinColumn(name = "festival_id")
    private Festival festival;

    @Builder
    public FestivalImage(String url, Festival festival) {
        this.url = url;
        this.festival = festival;
        festival.getImages().add(this);
    }
}