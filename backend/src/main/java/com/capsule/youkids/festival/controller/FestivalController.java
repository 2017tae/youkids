package com.capsule.youkids.festival.controller;

import com.capsule.youkids.festival.service.FestivalService;
import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.common.response.BaseResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/festival")
@RequiredArgsConstructor
public class FestivalController {
    private final FestivalService festivalService;

    // state 상관 없이 랜덤 10개
    @GetMapping("/recomm")
    public BaseResponse<?> recommMixedFestivals() {
        try{
            return BaseResponse.success(Code.SUCCESS, festivalService.getMixedFestivalRecomm());
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // state 별로 랜덤 10개
    @GetMapping("/recommdiv")
    public BaseResponse<?> recommDivFestivals() {
        try {
            return BaseResponse.success(Code.SUCCESS, festivalService.getDivFestivalRecomm());
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // 공연 상세보기
    @GetMapping("/detail/{festivalId}")
    public BaseResponse<?> detailFestival(@PathVariable Long festivalId){
        try{
            return BaseResponse.success(Code.SUCCESS, festivalService.getDetailFestival(festivalId));
        }catch (RestApiException e){
            return BaseResponse.error(e.getErrorCode());
        }
    }
}
