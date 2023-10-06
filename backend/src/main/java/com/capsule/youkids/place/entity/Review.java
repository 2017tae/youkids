package com.capsule.youkids.place.entity;

import com.capsule.youkids.user.entity.User;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
public class Review {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int reviewId;

    @Column
    private double score;

    @Column
    private String description;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "place_id")
    private Place place;

    @OneToMany(mappedBy = "review")
    private List<ReviewImage> images = new ArrayList<>();

    @Builder
    public Review(double score, String description, User user, Place place) {
        this.score = score;
        this.description = description;
        this.user = user;
        this.place = place;
        place.getReviews().add(this);
        place.upReviewNum();
        place.addReviewSum(score);
    }

    public void UpdateReview(double score, String description) {
        this.score = score;
        this.description = description;
    }   
}
