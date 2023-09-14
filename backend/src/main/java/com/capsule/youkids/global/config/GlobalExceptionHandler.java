package com.capsule.youkids.global.config;

import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.common.response.BaseResponse;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(RestApiException.class)
    public BaseResponse handleCustomException(RestApiException exception) {
        return BaseResponse.error(exception.getErrorCode());
    }
}
