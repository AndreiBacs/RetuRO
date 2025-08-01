import { pgTable, serial, text, timestamp, varchar } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  fullName: text('full_name'),
  phone: varchar('phone', { length: 256 }),
});

export const tomraEvents = pgTable('tomra_events', {
  id: serial('id').primaryKey(),
  receivedOn: timestamp('received_on').notNull().defaultNow(),
  processedOn: timestamp('processed_on'),
  payload: text('payload'),
});

