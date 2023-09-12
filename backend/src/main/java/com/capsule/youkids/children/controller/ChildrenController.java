package com.capsule.youkids.children.controller;

import com.capsule.youkids.children.dto.request.ChildrenRequest;
import com.capsule.youkids.children.entity.Children;
import com.capsule.youkids.children.service.ChildrenService;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/children")
@RequiredArgsConstructor
public class ChildrenController {

    private final ChildrenService childrenService;

    @GetMapping("/parent/{id}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "부모의 아이 찾음"),
            @ApiResponse(responseCode = "404", description = "존재하지 않는 부모 id"),
    })
    public ResponseEntity<?> getParentsChildren(@PathVariable("id") UUID id) throws Exception {
        List<Children> children = childrenService.getParentsChildren(id);
        return new ResponseEntity<>(children, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "아이 찾음"),
            @ApiResponse(responseCode = "404", description = "존재하지 않는 아이 id"),
    })
    public ResponseEntity<?> findChildren(@PathVariable("id") long id) throws Exception {
        Children child = childrenService.findChildren(id);
        return new ResponseEntity<>(child, HttpStatus.OK);
    }

    @PostMapping()
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "아이 등록 성공"),
            @ApiResponse(responseCode = "404", description = "존재하지 않는 부모 id"),
            @ApiResponse(responseCode = "400", description = "알 수 없음"),
    })
    public ResponseEntity<?> registChildren(@RequestBody ChildrenRequest childrenRequest)
            throws Exception {
        Children child = childrenService.registChildren(childrenRequest);
        return new ResponseEntity<>(child, HttpStatus.OK);
    }

    @PutMapping()
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "아이 수정 성공"),
            @ApiResponse(responseCode = "404", description = "존재하지 않는 아이 id"),
            @ApiResponse(responseCode = "400", description = "알 수 없음"),
    })
    public ResponseEntity<?> updateChildren(@RequestBody ChildrenRequest childrenRequest)
            throws Exception {
        Children child = childrenService.updateChildren(childrenRequest);
        return new ResponseEntity<>(child, HttpStatus.OK);
    }
}
