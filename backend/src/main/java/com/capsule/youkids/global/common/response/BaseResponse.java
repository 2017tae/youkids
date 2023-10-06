package com.capsule.youkids.global.common.response;

import com.capsule.youkids.global.common.constant.Code;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@Getter
@ToString
@RequiredArgsConstructor
public class BaseResponse<T> {

    private final boolean isSuccess;
    private final int code;
    private final String message;
    // result가 없으면 json에 포함하지 않음
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private T result;

    // result 데이터가 있으면
    private BaseResponse(Code code, T result) {
        this.isSuccess = code.isSuccess();
        this.code = code.getCode();
        this.message = code.getMessage();
        this.result = result;
    }

    // result 데이터가 없으면
    private BaseResponse(Code code) {
        this.isSuccess = code.isSuccess();
        this.code = code.getCode();
        this.message = code.getMessage();
    }

    // 요청 성공, result 있으면
    public static <T> BaseResponse<T> success(Code code, T result) {
        return new BaseResponse<>(code, result);
    }

    // 요청 성공, result 없으면
    public static <T> BaseResponse<T> success(Code successCode) {
        return new BaseResponse<>(successCode);
    }

    // 요청 에러 처리
    public static <T> BaseResponse<T> error(Code errorCode) {
        return new BaseResponse<>(errorCode);
    }
}
