package com.capsule.youkids.place.dto;

import java.util.List;
import lombok.Builder;
import lombok.NoArgsConstructor;

@NoArgsConstructor
public class BookmarkListResponseDto {

    List<BookmarkListItemDto> bookmarks;

    @Builder
    public BookmarkListResponseDto(List<BookmarkListItemDto> bookmarks) {
        this.bookmarks = bookmarks;
    }
}
