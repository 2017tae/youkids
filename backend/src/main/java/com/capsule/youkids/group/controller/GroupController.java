package com.capsule.youkids.group.controller;

import com.capsule.youkids.group.dto.request.GroupUserRequest;
import com.capsule.youkids.group.dto.request.UpdateGroupRequest;
import com.capsule.youkids.group.dto.response.GroupResponse;
import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.service.GroupService;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
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
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/group")
@RequiredArgsConstructor
public class GroupController {

    private final GroupService groupService;

    @PostMapping()
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "추가 성공"),
            @ApiResponse(responseCode = "404", description = "정보가 존재하지 않음"),
            @ApiResponse(responseCode = "400", description = "이미 추가된 유저")
    })
    public ResponseEntity<?> addUserInGroup(@RequestBody GroupUserRequest groupUserRequest) {
        groupService.addUserInGroup(groupUserRequest);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping()
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "삭제 성공"),
            @ApiResponse(responseCode = "404", description = "정보가 존재하지 않음"),
            @ApiResponse(responseCode = "400", description = "그룹에 속해있지 않음")
    })
    public ResponseEntity<?> deleteUserFromGroup(@RequestBody GroupUserRequest groupUserRequest) {
        groupService.deleteUserFromGroup(groupUserRequest);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping()
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수정 성공"),
            @ApiResponse(responseCode = "404", description = "정보가 존재하지 않음"),
            @ApiResponse(responseCode = "400", description = "그룹에 속해있지 않음")
    })
    public ResponseEntity<?> updateGroupName(@RequestBody UpdateGroupRequest updateGroupRequest) {
        groupService.updateGroupName(updateGroupRequest);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/{id}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "그룹 불러오기 성공"),
            @ApiResponse(responseCode = "404", description = "정보가 존재하지 않음"),
    })
    public ResponseEntity<?> getAllJoinedGroup(@PathVariable("id") UUID id) {
        GroupResponse groupResponse = groupService.getAllJoinedGroup(id);
        return new ResponseEntity<>(groupResponse, HttpStatus.OK);
    }

}
