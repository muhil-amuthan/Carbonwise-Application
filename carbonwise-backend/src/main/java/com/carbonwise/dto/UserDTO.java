package com.carbonwise.dto;
import lombok.*;
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class UserDTO { private String id; private String name; private String email; private String role; private String phone; private String city; private String profileImage; private Boolean isVerified; }
