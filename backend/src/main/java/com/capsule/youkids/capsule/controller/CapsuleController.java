package com.capsule.youkids.capsule.controller;


import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CreateMemoryRequestDto;
import com.capsule.youkids.capsule.dto.MemoryDeleteRequestDto;
import com.capsule.youkids.capsule.dto.MemoryDetailResponseDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.dto.MemoryUpdateRequestDto;
import com.capsule.youkids.capsule.service.CapsuleService;
import com.capsule.youkids.global.common.constant.Code;
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

    @GetMapping("/all/{email}")
    public BaseResponse getAllCapsuleList(@PathVariable String email) {

        // 에러처리 해야한다.
        CapsuleListResponseDto capsuleListResponseDto = capsuleService.getCapsuleList(email);

        return BaseResponse.success(Code.SUCCESS, capsuleListResponseDto);
    }

    @GetMapping("/images/{capsuleId}")
    public BaseResponse getAllMemoryByCapsule(@PathVariable int capsuleId) {

        // 에러처리 해야한다.
        return BaseResponse.success(Code.SUCCESS, capsuleService.getMemoryList(capsuleId));
    }

    @PostMapping("/upload")
    public BaseResponse createMemory(@RequestPart CreateMemoryRequestDto request,
                                     @RequestPart(required = false) List<MultipartFile> fileList) {

        // 에러처리 해야한다.
        capsuleService.createMemory(request, fileList);

        return BaseResponse.success(Code.SUCCESS);
    }

    @GetMapping("/memory/{memoryId}")
    public BaseResponse getMemory(@RequestParam long memoryId) {

        return BaseResponse.success(Code.SUCCESS, capsuleService.getMemoryDetail(memoryId));
    }

    @PutMapping("/memory")
    public BaseResponse updateMemory(@RequestBody MemoryUpdateRequestDto request) {

        // 에러 처리 해야한다.
        capsuleService.updateMemory(request);

        return BaseResponse.success(Code.SUCCESS);
    }

    @DeleteMapping("/memory")
    public BaseResponse deleteMemory(@RequestBody MemoryDeleteRequestDto request) {

        // 에러 처리 해야한다.
        capsuleService.deleteMemory(request);

        return BaseResponse.success(Code.SUCCESS);
    }
}
