package com.capsule.youkids.children.service;

import com.capsule.youkids.children.dto.request.ChildrenRegistRequest;
import com.capsule.youkids.children.dto.request.ChildrenRequest;
import com.capsule.youkids.children.dto.response.ChildrenResponse;
import com.capsule.youkids.children.entity.Children;
import com.capsule.youkids.children.repository.ChildrenRepository;
import com.capsule.youkids.user.entity.Role;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class ChildrenServiceImpl implements ChildrenService {

    private final UserRepository userRepository;
    private final ChildrenRepository childrenRepository;

    @Override
    public ChildrenResponse findChildren(long childrenId) throws Exception {
        Optional<Children> child = childrenRepository.findById(childrenId);
        if (child.isPresent()) {
            Children result = child.get();
            ChildrenResponse cr = ChildrenResponse.builder()
                    .childrenId(result.getChildrenId())
                    .name(result.getName())
                    .gender(result.getGender())
                    .birthday(result.getBirthday())
                    .childrenImage(result.getChildrenImage())
                    .build();
            return cr;
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no children id");
    }

    @Override
    public List<ChildrenResponse> getParentsChildren(UUID id) throws Exception {
        // 부모 찾기(String email
        Optional<User> user = userRepository.findById(id);
        // 유저가 있으면
        if (user.isPresent()) {
            // 리더면
            if (user.get().isLeader()) {
                List<Children> children = childrenRepository.findAllByParentOrderByBirthday(user.get());
                List<ChildrenResponse> childrenResponseList = new ArrayList<>();
                for (Children c : children) {
                    ChildrenResponse cr = ChildrenResponse.builder()
                            .childrenId(c.getChildrenId())
                            .name(c.getName())
                            .gender(c.getGender())
                            .birthday(c.getBirthday())
                            .childrenImage(c.getChildrenImage())
                            .build();
                    childrenResponseList.add(cr);
                }
                return childrenResponseList;
                // 리더가 아니면 파트너 아이디 가져와서 애기 찾기
            } else {
                Optional<User> partner = userRepository.findById(user.get().getPartnerId());
                List<Children> children = childrenRepository.findAllByParentOrderByBirthday(partner.get());
                List<ChildrenResponse> childrenResponseList = new ArrayList<>();
                for (Children c : children) {
                    ChildrenResponse cr = ChildrenResponse.builder()
                            .childrenId(c.getChildrenId())
                            .name(c.getName())
                            .gender(c.getGender())
                            .birthday(c.getBirthday())
                            .childrenImage(c.getChildrenImage())
                            .build();
                    childrenResponseList.add(cr);
                }
                return childrenResponseList;
            }
        }
        // 아님 에러
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no parent info");
    }

    @Override
    public void registChildren(ChildrenRegistRequest childrenRegistRequest) throws Exception {
        // 부모 찾기
        Optional<User> user = userRepository.findById(childrenRegistRequest.getParentId());
        // 부모가 있으면
        if (user.isPresent()) {
            try {
                // 애기를 만들어서 repository에 등록하세요
                Children children = Children.builder().
                        parent(user.get()).
                        name(childrenRegistRequest.getName()).
                        gender(childrenRegistRequest.getGender()).
                        birthday(childrenRegistRequest.getBirthday()).
                        childrenImage(childrenRegistRequest.getChildrenImage()).
                        build();
                childrenRepository.save(children);
                // 등록된 애기에서 애기 아이디 받는 법을 모름;
            } catch (Exception e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "unknown");
            }
            // 부모가 없으면
        } else {
            // 에러를 만드세요
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no parent id");
        }
    }

    @Override
    public void updateChildren(ChildrenRequest childrenRequest) throws Exception {
        Optional<Children> children = childrenRepository.findById(childrenRequest.getChildrenId());
        // 애기가 있으면 고치고
        if (children.isPresent()) {
            try {
                children.get().updateChildren(childrenRequest.getName(), childrenRequest.getGender(), childrenRequest.getBirthday(), childrenRequest.getChildrenImage());
                childrenRepository.save(children.get());
            } catch (Exception e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "unknown");
            }

            // 애기 없으면 에러~
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no children id");
        }
    }
}
