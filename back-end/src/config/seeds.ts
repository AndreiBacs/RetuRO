import db from './db.ts';
import { User } from '../models/user.ts';
import { TomraTrigger } from '../models/tomra_trigger.ts';

// Seed development data
export async function seedDatabase() {
  try {
    console.log('🌱 Starting database seeding...');

    // Seed users
    const users = [
      {
        name: 'John Doe',
        email: 'john.doe@example.com',
      },
      {
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
      },
      {
        name: 'Admin User',
        email: 'admin@returo.com',
      },
    ];

    for (const userData of users) {
      try {
        await User.create(userData);
        console.log(`✅ Created user: ${userData.email}`);
      } catch (error) {
        // User might already exist, that's okay
        console.log(`ℹ️  User ${userData.email} already exists`);
      }
    }

    // Seed sample tomra triggers
    const triggers = [
      {
        trigger: JSON.stringify({
          type: 'bottle_return',
          timestamp: new Date().toISOString(),
          machine_id: 'TOMRA_001',
          bottle_count: 5,
        }),
      },
      {
        trigger: JSON.stringify({
          type: 'can_return',
          timestamp: new Date().toISOString(),
          machine_id: 'TOMRA_002',
          can_count: 3,
        }),
      },
    ];

    for (const triggerData of triggers) {
      try {
        await TomraTrigger.create(triggerData);
        console.log(`✅ Created tomra trigger: ${triggerData.trigger.substring(0, 50)}...`);
      } catch (error) {
        console.log(`ℹ️  Trigger already exists`);
      }
    }

    console.log('✅ Database seeding completed successfully');
  } catch (error) {
    console.error('❌ Database seeding failed:', error);
    throw error;
  }
}

// Clear all data (for development)
export async function clearDatabase() {
  try {
    console.log('🗑️  Clearing database...');
    
    // Use raw SQL to clear tables
    await db.query("DELETE FROM tomra_triggers" as any);
    await db.query("DELETE FROM users" as any);
    
    console.log('✅ Database cleared successfully');
  } catch (error) {
    console.error('❌ Database clearing failed:', error);
    throw error;
  }
}

// Check if database is empty
export async function isDatabaseEmpty(): Promise<boolean> {
  try {
    const userCount = await User.count();
    const triggerCount = await TomraTrigger.count();
    
    return userCount === 0 && triggerCount === 0;
  } catch (error) {
    console.error('Error checking database emptiness:', error);
    return true; // Assume empty if we can't check
  }
} 