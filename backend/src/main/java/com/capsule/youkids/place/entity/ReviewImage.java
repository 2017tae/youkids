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
import org.hibernate.annotations.Index;

@Getter
@NoArgsConstructor
@Entity
public class ReviewImage {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int reviewImageId;

    @Column
    private String imageUrl;

    @ManyToOne
    @JoinColumn(name = "review_id")
    private Review review;

    @Column
    @Index(name = "idx_place_id")
    private int placeId;

    @Builder
    public ReviewImage(String imageUrl, Review review, int placeId) {
        this.imageUrl = imageUrl;
        this.review = review;
        this.placeId = placeId;
        review.getImages().add(this);
    }

    @Override
    public String toString() {
        return "ReviewImage{" +
                "reviewImageId=" + reviewImageId +
                ", imageUrl='" + imageUrl + '\'' +
                ", placeId=" + placeId +
                '}';
    }
}
