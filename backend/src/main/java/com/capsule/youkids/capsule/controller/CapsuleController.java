package com.capsule.youkids.capsule.controller;


import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CreateMemoryRequestDto;
import com.capsule.youkids.capsule.dto.MemoryDeleteRequestDto;
import com.capsule.youkids.capsule.dto.MemoryDetailResponseDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.dto.MemoryUpdateRequestDto;
import com.capsule.youkids.capsule.service.CapsuleService;
import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.common.response.BaseResponse;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping(value = "/capsule")
@RequiredArgsConstructor
public class CapsuleController {

    private final CapsuleService capsuleService;

    /**
     * 유저 아이디를 통해서 아이디에 해당하는 모든 캡슐을 가져온다.
     *
     * @param userId
     * @return
     */
    @GetMapping("/all/{userId}")
    public BaseResponse getAllCapsuleList(@PathVariable UUID userId) {

        try {
            CapsuleListResponseDto response = capsuleService.getCapsuleList(userId);
            return BaseResponse.success(Code.SUCCESS, response);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }

    }

    /**
     * 캡슐 아이디를 통해서 캡슐에 해당하는 모든 메모리를 가져온다.
     *
     * @param capsuleId
     * @return
     */
    @GetMapping("/images/{capsuleId}")
    public BaseResponse getAllMemoryByCapsule(@PathVariable int capsuleId) {

        try {
            MemoryListResponseDto response = capsuleService.getMemoryList(capsuleId);
            return BaseResponse.success(Code.SUCCESS, response);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    /**
     * 메모리를 생성한다.
     *
     * @param request
     * @param fileList
     * @return
     */
    @PostMapping("/upload")
    public BaseResponse createMemory(@RequestPart CreateMemoryRequestDto request,
            @RequestPart(required = false) List<MultipartFile> fileList) {

        try {
            capsuleService.createMemory(request, fileList);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }

    }

    @GetMapping("/memory/{memoryId}")
    public BaseResponse getMemory(@PathVariable long memoryId) {

        try {
            MemoryDetailResponseDto response = capsuleService.getMemoryDetail(memoryId);
            return BaseResponse.success(Code.SUCCESS, response);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }

    }

    /**
     * 메모리를 수정한다.
     *
     * @param request
     * @return
     */
    @PutMapping("/memory")
    public BaseResponse updateMemory(@RequestBody MemoryUpdateRequestDto request) {

        try {
            capsuleService.updateMemory(request);
            return BaseResponse.success(Code.SUCCESS);

        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }

    }

    /**
     * 메모리를 삭제한다.
     *
     * @param request
     * @return
     */
    @DeleteMapping("/memory")
    public BaseResponse deleteMemory(@RequestBody MemoryDeleteRequestDto request) {

        // 에러 처리 해야한다.
        try {
            capsuleService.deleteMemory(request);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }

    }
}
