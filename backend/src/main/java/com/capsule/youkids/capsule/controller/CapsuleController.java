package com.capsule.youkids.capsule.controller;


import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CreateMemoryRequestDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.service.CapsuleService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
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

    @GetMapping("/all/{userId}")
    public ResponseEntity<?> getAllCapsuleList(@PathVariable UUID userId) {
        CapsuleListResponseDto capsuleListResponseDto = capsuleService.getCapsuleList(userId);

        return new ResponseEntity<>(capsuleListResponseDto, HttpStatus.OK);
    }

    @GetMapping("/images/{capsuleId}")
    public ResponseEntity<?> getAllMemoryByCapsule(@PathVariable int capsuleId) {

        MemoryListResponseDto memoryListResponseDto = capsuleService.getMemoryList(capsuleId);

        return new ResponseEntity<>(memoryListResponseDto, HttpStatus.OK);
    }

    @PostMapping("/upload")
    public ResponseEntity<?> createMemory(@RequestPart CreateMemoryRequestDto dto,
            @RequestPart(required = false) List<MultipartFile> fileList){
        return null;
    }
}
