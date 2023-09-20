package com.capsule.youkids.place.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BookmarkListResponseDto {

    List<BookmarkListItemDto> bookmarks;

    @Builder
    public BookmarkListResponseDto(List<BookmarkListItemDto> bookmarks) {
        this.bookmarks = bookmarks;
    }
}
