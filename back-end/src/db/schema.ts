import {
  pgTable,
  serial,
  text,
  timestamp,
  varchar,
  decimal,
  pgEnum,
  integer,
} from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm";

export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  fullName: text("full_name"),
  phone: varchar("phone", { length: 256 }),
});

export const tomraEvents = pgTable("tomra_events", {
  id: serial("id").primaryKey(),
  receivedOn: timestamp("received_on").notNull().defaultNow(),
  processedOn: timestamp("processed_on"),
  payload: text("payload"),
});

// Producer: Tomra, Philips, others
export const producers = pgTable("producers", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  address_line_1: text("address_line_1").notNull(),
  address_line_2: text("address_line_2"),
  city: text("city").notNull(),
  state: text("state").notNull(),
  zip: varchar("zip", { length: 256 }).notNull(),
  country: text("country").notNull(),
  phone: varchar("phone", { length: 256 }),
  email: varchar("email", { length: 256 }),
  website: varchar("website", { length: 256 }),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const producerRelations = relations(producers, ({ many }) => ({
  rvms: many(rvms),
}));

// Location: location where the machine is installed
export const locations = pgTable("locations", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  customer_id: varchar("customer_id", { length: 256 }),
  customer_name: text("customer_name"),
  address_line_1: text("address_line_1").notNull(),
  address_line_2: text("address_line_2"),
  city: text("city").notNull(),
  state: text("state").notNull(),
  zip: varchar("zip", { length: 256 }).notNull(),
  country: text("country").notNull(),
  latitude: decimal("latitude"),
  longitude: decimal("longitude"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const locationRelations = relations(locations, ({ many }) => ({
  rvms: many(rvms),
}));

// RVMs: Return Vending Machines
export const rvms = pgTable("rvms", {
  id: serial("id").primaryKey(),
  serial_number: varchar("serial_number", { length: 256 }).notNull(),
  type: text("type").notNull(),
  location_id: integer("location_id")
    .notNull()
    .references(() => locations.id),
  producer_id: integer("producer_id")
    .notNull()
    .references(() => producers.id),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const rvmRelations = relations(rvms, ({ one, many }) => ({
  location: one(locations, {
    fields: [rvms.location_id],
    references: [locations.id],
  }),
  producer: one(producers, {
    fields: [rvms.producer_id],
    references: [producers.id],
  }),
  connection_status: many(connection_status),
  machine_status: many(machine_status),
}));

// Machine Status: up, down
export const machine_status_enum = pgEnum("machine_status_enum", [
  "up",
  "down",
]);

export const machine_status = pgTable("machine_status", {
  id: serial("id").primaryKey(),
  status: machine_status_enum("status").default("up"),
  rvm_id: integer("rvm_id")
    .notNull()
    .references(() => rvms.id),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const machineStatusRelations = relations(
  machine_status,
  ({ one, many }) => ({
    rvm: one(rvms, {
      fields: [machine_status.rvm_id],
      references: [rvms.id],
    }),
    machine_status_details: many(machine_status_details),
  })
);

// Machine Status Details:
export const machine_status_details_enum = pgEnum("machine_status_details_enum", [
  "chamberBlocked",
  "closed",
  "closedUpdate",
  "emergency",
  "emptyingBin",
  "errorBackroom",
  "errorOther",
  "frontDoorOpen",
  "fullBin",
  "fullConveyor",
  "fullTable",
  "printerOutOfPaper",
  "printerStoreResolvable",
  "printerOther",
  "standby",
  "temporaryClosed",
  "temporaryClosedRearDoorOpen",
  "temporaryClosedMachineBeingEmptied",
  "temporaryClosedResetButton",
  "temporaryClosedNeedsEmptying",
  "temporaryClosedBackroomNotReady",
  "other",
]);
export const machine_status_details = pgTable("machine_status_details", {
  id: serial("id").primaryKey(),
  machine_status_id: integer("machine_status_id")
    .notNull()
    .references(() => machine_status.id),
  reason: machine_status_details_enum("reason"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export const machineStatusDetailsRelations = relations(
  machine_status_details,
  ({ one }) => ({
    machine_status: one(machine_status, {
      fields: [machine_status_details.machine_status_id],
      references: [machine_status.id],
    }),
  })
);

// Connection Status: online, offline
export const connection_status_enum = pgEnum("connection_status_enum", [
  "online",
  "offline",
]);

export const connection_status = pgTable("connection_status", {
  id: serial("id").primaryKey(),
  status: connection_status_enum("status").default("offline"),
  rvm_id: integer("rvm_id")
    .notNull()
    .references(() => rvms.id),
  last_seen: timestamp("last_seen").notNull(),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const connectionStatusRelations = relations(
  connection_status,
  ({ one }) => ({
    rvm: one(rvms, {
      fields: [connection_status.rvm_id],
      references: [rvms.id],
    }),
  })
);
