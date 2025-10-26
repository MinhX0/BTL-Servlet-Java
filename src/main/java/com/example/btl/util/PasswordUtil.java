package com.example.btl.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification using BCrypt
 * BCrypt is the industry standard for secure password storage
 */
public class PasswordUtil {

    /**
     * Hash a plain text password using BCrypt
     * BCrypt includes salt generation and is resistant to brute force attacks
     *
     * @param plainPassword The plain text password to hash
     * @return The hashed password
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        // Generate salt with 12 rounds (default is 10, 12 is good for security)
        // Higher rounds = slower = more secure but slower login
        String salt = BCrypt.gensalt(12);
        return BCrypt.hashpw(plainPassword, salt);
    }

    /**
     * Verify a plain text password against a hashed password
     *
     * @param plainPassword The plain text password to verify
     * @param hashedPassword The hashed password from database
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Invalid hash format
            return false;
        }
    }

    /**
     * Test the password utility
     */
    public static void main(String[] args) {
        String plainPassword = "test123";

        // Hash the password
        String hashedPassword = hashPassword(plainPassword);
        System.out.println("Plain Password: " + plainPassword);
        System.out.println("Hashed Password: " + hashedPassword);

        // Verify correct password
        boolean isCorrect = verifyPassword(plainPassword, hashedPassword);
        System.out.println("Password correct: " + isCorrect); // true

        // Verify wrong password
        boolean isWrong = verifyPassword("wrongpassword", hashedPassword);
        System.out.println("Wrong password: " + isWrong); // false
    }
}

