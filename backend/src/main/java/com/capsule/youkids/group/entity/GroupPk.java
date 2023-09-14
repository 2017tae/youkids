package com.capsule.youkids.group.entity;

import java.io.Serializable;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class GroupPk implements Serializable {

    @EqualsAndHashCode.Include
    private Long groupId;

    @EqualsAndHashCode.Include
    private UUID userId;
}
