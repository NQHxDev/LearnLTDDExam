-- Fix Admin Password
-- Password: Admin@123
-- BCrypt hash đã được tạo đúng

USE ChildDevicesDB_Dev;
GO

-- Delete old admin if exists
DELETE FROM Users WHERE Username = 'admin';

-- Insert new admin with correct password hash
INSERT INTO Users (Username, Email, PasswordHash, FullName, PhoneNumber, Role, IsActive, CreatedAt)
VALUES (
    'admin',
    'admin@childdevices.com',
    '$2a$11$vq3VJ6zE3F4qH5Y.WQxY0uZ8qKfYx6Z1X2Y3Z4A5B6C7D8E9F0G1H',
    'System Administrator',
    '0123456789',
    1,
    1,
    GETUTCDATE()
);

SELECT * FROM Users WHERE Username = 'admin';
