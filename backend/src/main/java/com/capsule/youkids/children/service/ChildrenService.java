package com.capsule.youkids.children.service;

import com.capsule.youkids.children.dto.request.ChildrenRequest;
import com.capsule.youkids.children.entity.Children;
import java.util.List;
import java.util.UUID;

public interface ChildrenService {
    // 애기 id로 애기 검색하기
    public Children findChildren(long childrenId) throws Exception;

    // 부모 id로 애기들 검색하기
    public List<Children> getParentsChildren(UUID id) throws Exception;

    // 애기 등록하기
    public Children registChildren(ChildrenRequest childrenRequest) throws Exception;

    // 애기 수정하기
    public Children updateChildren(ChildrenRequest childrenRequest) throws Exception;
}
