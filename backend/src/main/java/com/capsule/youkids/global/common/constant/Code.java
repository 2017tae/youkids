package com.capsule.youkids.global.common.constant;

import lombok.Getter;

@Getter
public enum Code {

    /**
     * 성공 코드
     */
    SUCCESS(true, 1000, "요청에 성공하였습니다."),

    /**
     * 에러 코드
     */
    // 코스 에러 (1001 ~ 1010)
    COURSE_NOT_FOUND(false, 1001, "코스를 찾을 수 없습니다."),
    COURSE_LIST_NOT_FOUND(false, 1002, "생성된 코스가 없습니다."),
    COURSE_PLACE_ITEM_NOT_FOUND(false, 1003, "코스의 정보를 찾을 수 없습니다."),
    COURSE_COUNT_FULL(false, 1004, "더 이상 코스를 생성할 수 없습니다."),

    // 유저 에러 (1011 ~ 1020)
    USER_NOT_FOUND(false, 1011, "존재하지 않는 유저입니다."),

    // 장소 에러 (1021 ~ 1030)
    PLACE_NOT_FOUND(false, 1021, "해당 장소를 찾을 수 없습니다.");

    // (1031 ~ 1040)


    private final boolean isSuccess;
    private final int code;
    private final String message;

    Code(boolean isSuccess, int code, String message) {
        this.isSuccess = isSuccess;
        this.code = code;
        this.message = message;
    }
}
