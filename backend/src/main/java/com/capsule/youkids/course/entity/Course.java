package com.capsule.youkids.course.entity;

import com.capsule.youkids.global.time.BaseTimeEntity;
import com.capsule.youkids.user.entity.User;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor
public class Course extends BaseTimeEntity {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer courseId;

    @Column
    private String courseName;

    @Column(columnDefinition = "BOOLEAN default false")
    private Boolean flag;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
