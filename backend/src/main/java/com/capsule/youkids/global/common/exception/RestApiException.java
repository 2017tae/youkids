package com.capsule.youkids.global.common.exception;

import com.capsule.youkids.global.common.constant.Code;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class RestApiException extends RuntimeException {

    private final Code errorCode;
}
