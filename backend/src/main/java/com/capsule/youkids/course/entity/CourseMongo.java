package com.capsule.youkids.course.entity;

import com.capsule.youkids.course.dto.PlaceDto;
import java.util.List;
import java.util.UUID;
import javax.persistence.Column;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document(collection = "courseItem")
@Getter
@NoArgsConstructor
public class CourseMongo {

    @Id
    @Column(columnDefinition = "BINARY(16)")
    private UUID course_id;

    private String courseName;

    @Field("places")
    private List<PlaceDto> places;

    @Builder
    public CourseMongo(UUID course_id, String courseName, List<PlaceDto> places){
        this.course_id = course_id;
        this.courseName=courseName;
        this.places=places;
    }
}
