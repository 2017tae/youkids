package com.capsule.youkids.group.controller;

import com.capsule.youkids.group.dto.request.GroupUserRequest;
import com.capsule.youkids.group.dto.request.RegistUserRequest;
import com.capsule.youkids.group.dto.request.UpdateGroupRequest;
import com.capsule.youkids.group.dto.response.GroupResponse;
import com.capsule.youkids.group.dto.response.UserResponse;
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
    // 리더 id와 등록 대상 유저 email을 받아와서 리더가 자신의 그룹에 유저를 등록함
    public ResponseEntity<?> addUserInGroup(@RequestBody RegistUserRequest registUserRequest) throws Exception {
        groupService.addUserInGroup(registUserRequest);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping()
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "삭제 성공"),
            @ApiResponse(responseCode = "404", description = "정보가 존재하지 않음"),
            @ApiResponse(responseCode = "400", description = "그룹에 속해있지 않음")
    })
    // 리더 id와 등록 대상 유저 id를 받아와서 리더가 자신의 그룹에서 유저를 추방함
    public ResponseEntity<?> deleteUserFromGroup(@RequestBody GroupUserRequest groupUserRequest) throws Exception {
        groupService.deleteUserFromGroup(groupUserRequest);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping()
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수정 성공"),
            @ApiResponse(responseCode = "404", description = "정보가 존재하지 않음"),
            @ApiResponse(responseCode = "400", description = "그룹에 속해있지 않음")
    })
    // 그룹 id, 내 id, 새 이름을 보내서 내가 부르는 그룹 이름을 바꿈
    public ResponseEntity<?> updateGroupName(@RequestBody UpdateGroupRequest updateGroupRequest) throws Exception {
        groupService.updateGroupName(updateGroupRequest);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/mygroup/{id}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "그룹 불러오기 성공"),
            @ApiResponse(responseCode = "404", description = "정보가 존재하지 않음"),
    })
    // 내 id로 내가 속한 그룹 불러오기
    public ResponseEntity<?> getAllJoinedGroup(@PathVariable("id") UUID id) throws Exception {
        List<GroupResponse> groupResponseList = groupService.getAllJoinedGroup(id);
        return new ResponseEntity<>(groupResponseList, HttpStatus.OK);
    }

    @GetMapping("/member/{id}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "멤버 불러오기 성공"),
            @ApiResponse(responseCode = "404", description = "그룹 정보가 존재하지 않음")
    })
    // 그룹 id로 속한 유저 불러오기
    public ResponseEntity<?> getAllJoinedUser(@PathVariable("id") UUID id) throws Exception {
        List<UserResponse> userResponseList = groupService.getAllJoinedUser(id);
        return new ResponseEntity<>(userResponseList, HttpStatus.OK);
    }

}
