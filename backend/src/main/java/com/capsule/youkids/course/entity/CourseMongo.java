package com.capsule.youkids.course.entity;

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
    private UUID courseId;

    private String courseName;

    @Field("places")
    private List<PlaceItem> places;

    @Builder
    public CourseMongo(UUID courseId, String courseName, List<PlaceItem> places) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.places = places;
    }


    @Getter
    @NoArgsConstructor
    public static class PlaceItem {

        private Integer placeId;
        private String name;
        private String address;
        private Double latitude;
        private Double longitude;
        private String category;
        private Integer order;

        @Builder
        public PlaceItem(Integer placeId, String name, String address, Double latitude,
                Double longitude,
                String category, Integer order) {
            this.placeId = placeId;
            this.name = name;
            this.address = address;
            this.latitude = latitude;
            this.longitude = longitude;
            this.category = category;
            this.order = order;
        }
    }
}
