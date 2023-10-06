package com.capsule.youkids.user.repository;

import com.capsule.youkids.user.entity.Role;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.capsule.youkids.user.entity.User;

public interface UserRepository extends JpaRepository<User, UUID> {


    Optional<User> findByEmailAndRoleNot(String email, Role role);

    Optional<User> findByProviderId(String providerId);

    Optional<User> findByUserIdAndRoleNot(UUID userId, Role role);

}
