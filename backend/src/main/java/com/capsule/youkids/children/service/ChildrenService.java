package com.capsule.youkids.children.service;

import com.capsule.youkids.children.dto.request.ChildrenRegistRequest;
import com.capsule.youkids.children.dto.request.ChildrenRequest;
import com.capsule.youkids.children.dto.response.ChildrenResponse;
import com.capsule.youkids.children.entity.Children;
import java.util.List;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public interface ChildrenService {

    // 애기 id로 애기 검색하기
    public ChildrenResponse findChildren(long childrenId) throws Exception;

    // 부모 email로 애기들 검색하기
    public List<ChildrenResponse> getParentsChildren(UUID id) throws Exception;

    // 애기 등록하기
    public void registChildren(ChildrenRegistRequest childrenRegistRequest, MultipartFile file) throws Exception;

    // 애기 수정하기
    public void updateChildren(ChildrenRequest childrenRequest, MultipartFile file) throws Exception;
}
