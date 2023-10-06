package com.capsule.youkids.place.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@Getter
@Document(collection = "bookmark")
public class BookmarkMongo {

    @Id
    private String id;

    private boolean isBookmarked;

    @Builder
    public BookmarkMongo(String id, boolean isBookmarked) {
        this.id = id;
        this.isBookmarked = isBookmarked;
    }
}
