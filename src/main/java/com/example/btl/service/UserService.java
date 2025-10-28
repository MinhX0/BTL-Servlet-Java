package com.example.btl.service;

import com.example.btl.dao.UserDAO;
import com.example.btl.dto.UserCreateRequest;
import com.example.btl.model.Role;
import com.example.btl.model.User;

import java.util.EnumSet;

public class UserService {
    private final UserDAO userDAO;
    private static final EnumSet<Role> ASSIGNABLE_ROLES = EnumSet.allOf(Role.class);

    public UserService(UserDAO userDAO) { this.userDAO = userDAO; }

    public boolean createUserAsAdmin(User actor, UserCreateRequest request) {
        if (actor == null || actor.getRole() != Role.ADMIN) {
            throw new SecurityException("Only ADMIN can create users.");
        }
        if (request == null || isBlank(request.getUsername()) || isBlank(request.getEmail())
                || isBlank(request.getPassword()) || isBlank(request.getName()) || request.getRole() == null) {
            throw new IllegalArgumentException("Missing required fields.");
        }
        if (!ASSIGNABLE_ROLES.contains(request.getRole())) {
            throw new IllegalArgumentException("Requested role is not assignable.");
        }
        if (userDAO.usernameExists(request.getUsername())) {
            throw new IllegalArgumentException("Username already exists.");
        }
        if (userDAO.emailExists(request.getEmail())) {
            throw new IllegalArgumentException("Email already exists.");
        }

        User newUser = new User();
        newUser.setUsername(request.getUsername());
        newUser.setEmail(request.getEmail());
        newUser.setPassword(request.getPassword()); // DAO will hash
        newUser.setName(request.getName());
        newUser.setPhoneNumber(request.getPhoneNumber());
        newUser.setAddress(request.getAddress());
        newUser.setRole(request.getRole());

        return userDAO.registerUser(newUser);
    }

    public boolean updateUserRoleAsAdmin(User actor, int userId, Role newRole) {
        if (actor == null || actor.getRole() != Role.ADMIN) {
            throw new SecurityException("Only ADMIN can change roles.");
        }
        if (newRole == null || !ASSIGNABLE_ROLES.contains(newRole)) {
            throw new IllegalArgumentException("Invalid role.");
        }
        User u = userDAO.getUserById(userId);
        if (u == null) return false;
        u.setRole(newRole);
        return userDAO.updateUser(u);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
