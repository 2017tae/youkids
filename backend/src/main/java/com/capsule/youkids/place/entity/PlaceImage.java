package com.capsule.youkids.place.entity;

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
public class PlaceImage {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int placeImageId;

    @Column
    private String url;

    @ManyToOne
    @JoinColumn(name = "place_id")
    private Place place;

    @Builder
    public PlaceImage(String url, Place place) {
        this.url = url;
        this.place = place;
        place.getImages().add(this);
    }
}
