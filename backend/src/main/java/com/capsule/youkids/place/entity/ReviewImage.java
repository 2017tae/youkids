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
public class ReviewImage {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int reviewImageId;

    @Column
    private String reviewUrl;

    @ManyToOne
    @JoinColumn(name = "review_id")
    private Review review;

    @Builder
    public ReviewImage(int reviewImageId, String reviewUrl, Review review) {
        this.reviewImageId = reviewImageId;
        this.reviewUrl = reviewUrl;
        this.review = review;
    }
}
