import { Context } from 'oak';
import { User, ApiResponse, CreateUserRequest, UpdateUserRequest } from '../types/index.ts';

// Mock database - in a real app, this would be a database
let users: User[] = [
  { id: 1, name: 'John Doe', email: 'john@example.com', createdAt: new Date(), updatedAt: new Date() },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com', createdAt: new Date(), updatedAt: new Date() }
];

export class UserController {
  // Get all users
  static async getAllUsers(ctx: Context) {
    try {
      const response: ApiResponse<User[]> = {
        success: true,
        data: users,
        message: 'Users retrieved successfully'
      };
      
      ctx.response.body = response;
    } catch (error: unknown) {
      ctx.response.status = 500;
      ctx.response.body = {
        success: false,
        error: 'Failed to retrieve users',
        message: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }

  // Get user by ID
  static async getUserById(ctx: Context) {
    try {
      const id = parseInt(ctx.params.id);
      const user = users.find(u => u.id === id);
      
      if (!user) {
        ctx.response.status = 404;
        ctx.response.body = {
          success: false,
          error: 'User not found'
        };
        return;
      }
      
      const response: ApiResponse<User> = {
        success: true,
        data: user,
        message: 'User retrieved successfully'
      };
      
      ctx.response.body = response;
    } catch (error: unknown) {
      ctx.response.status = 500;
      ctx.response.body = {
        success: false,
        error: 'Failed to retrieve user',
        message: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }

  // Create new user
  static async createUser(ctx: Context) {
    try {
      const body = await ctx.request.body().value as CreateUserRequest;
      
      if (!body.name || !body.email) {
        ctx.response.status = 400;
        ctx.response.body = {
          success: false,
          error: 'Name and email are required'
        };
        return;
      }
      
      const newUser: User = {
        id: users.length + 1,
        name: body.name,
        email: body.email,
        createdAt: new Date(),
        updatedAt: new Date()
      };
      
      users.push(newUser);
      
      const response: ApiResponse<User> = {
        success: true,
        data: newUser,
        message: 'User created successfully'
      };
      
      ctx.response.status = 201;
      ctx.response.body = response;
    } catch (error: unknown) {
      ctx.response.status = 500;
      ctx.response.body = {
        success: false,
        error: 'Failed to create user',
        message: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }

  // Update user
  static async updateUser(ctx: Context) {
    try {
      const id = parseInt(ctx.params.id);
      const body = await ctx.request.body().value as UpdateUserRequest;
      
      const userIndex = users.findIndex(u => u.id === id);
      
      if (userIndex === -1) {
        ctx.response.status = 404;
        ctx.response.body = {
          success: false,
          error: 'User not found'
        };
        return;
      }
      
      users[userIndex] = {
        ...users[userIndex],
        ...body,
        updatedAt: new Date()
      };
      
      const response: ApiResponse<User> = {
        success: true,
        data: users[userIndex],
        message: 'User updated successfully'
      };
      
      ctx.response.body = response;
    } catch (error: unknown) {
      ctx.response.status = 500;
      ctx.response.body = {
        success: false,
        error: 'Failed to update user',
        message: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }

  // Delete user
  static async deleteUser(ctx: Context) {
    try {
      const id = parseInt(ctx.params.id);
      const userIndex = users.findIndex(u => u.id === id);
      
      if (userIndex === -1) {
        ctx.response.status = 404;
        ctx.response.body = {
          success: false,
          error: 'User not found'
        };
        return;
      }
      
      const deletedUser = users.splice(userIndex, 1)[0];
      
      const response: ApiResponse<User> = {
        success: true,
        data: deletedUser,
        message: 'User deleted successfully'
      };
      
      ctx.response.body = response;
    } catch (error: unknown) {
      ctx.response.status = 500;
      ctx.response.body = {
        success: false,
        error: 'Failed to delete user',
        message: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }
} 