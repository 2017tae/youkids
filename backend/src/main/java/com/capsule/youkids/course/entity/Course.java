package com.capsule.youkids.course.entity;

import com.capsule.youkids.global.time.BaseTimeEntity;
import com.capsule.youkids.user.entity.User;
import java.util.UUID;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor
public class Course extends BaseTimeEntity {

    @Id
    @Column(columnDefinition = "BINARY(16)")
    private UUID courseId;

    @Column
    private String courseName;

    // false인 경우 글 등록 상태, true인 경우 글 삭제 상태
    @Column(columnDefinition = "BOOLEAN default false")
    private Boolean flag;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;


    @Builder
    public Course(UUID courseId, String courseName, Boolean flag, User user) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.flag = flag;
        this.user = user;
    }

    @Builder(builderMethodName = "updateCourseBuilder")
    public void updateCourse(String courseName, Boolean flag) {
        this.courseName = courseName;
        this.flag = flag;
    }
}
