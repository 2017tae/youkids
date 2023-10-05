package com.capsule.youkids.place.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
public class TopReviewPlace {
    @Id
    @Column
    private int placeId;

    @Column
    private String name;

    @Column
    private String address;

    @Column
    private String category;

    @Column
    private String imageUrl;

    @Column
    private int naverReviewNum;

    @Column
    private int visitedReviewNum;

    @Builder
    public TopReviewPlace(int placeId, String name, String address, String category,
            String imageUrl,
            int naverReviewNum, int visitedReviewNum) {
        this.placeId = placeId;
        this.name = name;
        this.address = address;
        this.category = category;
        this.imageUrl = imageUrl;
        this.naverReviewNum = naverReviewNum;
        this.visitedReviewNum = visitedReviewNum;
    }

    public TopReviewPlace(Place place) {
        this.placeId = place.getPlaceId();
        this.name = place.getName();
        this.address = place.getAddress();
        this.category = place.getCategory();
        this.imageUrl = place.getImages().isEmpty() ? "" : place.getImages().get(0).getUrl();
        this.naverReviewNum = place.getNaverReviewNum();
        this.visitedReviewNum = place.getVisitedReviewNum();
    }
}
