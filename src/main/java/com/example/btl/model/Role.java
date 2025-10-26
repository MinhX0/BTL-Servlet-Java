package com.example.btl.model;

/**
 * Enum representing user roles in the system
 */
public enum Role {
    CUSTOMER("CUSTOMER", "Customer"),
    ADMIN("ADMIN", "Administrator"),
    SELLER("SELLER", "Seller");

    private final String code;
    private final String displayName;

    Role(String code, String displayName) {
        this.code = code;
        this.displayName = displayName;
    }

    public String getCode() {
        return code;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Get Role from string code
     */
    public static Role fromCode(String code) {
        for (Role role : Role.values()) {
            if (role.code.equalsIgnoreCase(code)) {
                return role;
            }
        }
        return CUSTOMER; // Default role
    }

    @Override
    public String toString() {
        return displayName;
    }
}

