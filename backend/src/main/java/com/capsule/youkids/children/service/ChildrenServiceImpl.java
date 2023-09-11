package com.capsule.youkids.children.service;

import com.capsule.youkids.children.dto.request.ChildrenRequest;
import com.capsule.youkids.children.entity.Children;
import com.capsule.youkids.children.repository.ChildrenRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
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
    public Children findChildren(long childrenId) throws Exception {
        Optional<Children> child = childrenRepository.findById(childrenId);
        if (child.isPresent()) {
            return child.get();
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no children id");
    }

    @Override
    public List<Children> getParentsChildren(UUID id) throws Exception {
        // 부모 찾기
        Optional<User> user = userRepository.findById(id);
        // 부모 있으면 찾고
        if (user.isPresent()) {
            List<Children> children = childrenRepository.findAllByParentIdOrderByBirthday(id);
            return children;
        }
        // 아님 에러
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no parent id");
    }

    @Override
    public Children registChildren(ChildrenRequest childrenRequest) throws Exception {
        // 부모 찾기
        Optional<User> user = userRepository.findById(childrenRequest.getParentId());
        // 부모가 있으면
        if (user.isPresent()) {
            try {
                // 애기를 만들어서 repository에 등록하세요
                Children children = Children.builder().
                        parentId(childrenRequest.getParentId()).
                        name(childrenRequest.getName()).
                        gender(childrenRequest.getGender()).
                        birthday(childrenRequest.getBirthday()).
                        childrenImage(childrenRequest.getChildrenImage()).
                        build();
                childrenRepository.save(children);
                return children;
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
    public Children updateChildren(ChildrenRequest childrenRequest) throws Exception {
        Optional<Children> children = childrenRepository.findById(childrenRequest.getChildrenId());
        // 애기가 있으면 고치고
        if (children.isPresent()) {
            try {
                children.get().setName(childrenRequest.getName());
                children.get().setBirthday(childrenRequest.getBirthday());
                children.get().setChildrenImage(childrenRequest.getChildrenImage());
                children.get().setGender(childrenRequest.getGender());
                childrenRepository.save(children.get());
                return children.get();
            } catch (Exception e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "unknown");
            }

        // 애기 없으면 에러~
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no children id");
        }
    }
}
