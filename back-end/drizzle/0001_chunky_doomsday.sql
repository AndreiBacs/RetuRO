CREATE TYPE "public"."connection_status_enum" AS ENUM('online', 'offline');--> statement-breakpoint
CREATE TYPE "public"."machine_status_details_enum" AS ENUM('chamberBlocked', 'closed', 'closedUpdate', 'emergency', 'emptyingBin', 'errorBackroom', 'errorOther', 'frontDoorOpen', 'fullBin', 'fullConveyor', 'fullTable', 'printerOutOfPaper', 'printerStoreResolvable', 'printerOther', 'standby', 'temporaryClosed', 'temporaryClosedRearDoorOpen', 'temporaryClosedMachineBeingEmptied', 'temporaryClosedResetButton', 'temporaryClosedNeedsEmptying', 'temporaryClosedBackroomNotReady', 'other');--> statement-breakpoint
CREATE TYPE "public"."machine_status_enum" AS ENUM('up', 'down');--> statement-breakpoint
CREATE TABLE "connection_status" (
	"id" serial PRIMARY KEY NOT NULL,
	"status" "connection_status_enum" DEFAULT 'offline',
	"rvm_id" integer NOT NULL,
	"last_seen" timestamp NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "locations" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"customer_id" varchar(256),
	"customer_name" text,
	"address_line_1" text NOT NULL,
	"address_line_2" text,
	"city" text NOT NULL,
	"state" text NOT NULL,
	"zip" varchar(256) NOT NULL,
	"country" text NOT NULL,
	"latitude" numeric,
	"longitude" numeric,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "machine_status" (
	"id" serial PRIMARY KEY NOT NULL,
	"status" "machine_status_enum" DEFAULT 'up',
	"rvm_id" integer NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "machine_status_details" (
	"id" serial PRIMARY KEY NOT NULL,
	"machine_status_id" integer NOT NULL,
	"reason" "machine_status_details_enum",
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "producers" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"address_line_1" text NOT NULL,
	"address_line_2" text,
	"city" text NOT NULL,
	"state" text NOT NULL,
	"zip" varchar(256) NOT NULL,
	"country" text NOT NULL,
	"phone" varchar(256),
	"email" varchar(256),
	"website" varchar(256),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "rvms" (
	"id" serial PRIMARY KEY NOT NULL,
	"serial_number" varchar(256) NOT NULL,
	"type" text NOT NULL,
	"location_id" integer NOT NULL,
	"producer_id" integer NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "connection_status" ADD CONSTRAINT "connection_status_rvm_id_rvms_id_fk" FOREIGN KEY ("rvm_id") REFERENCES "public"."rvms"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "machine_status" ADD CONSTRAINT "machine_status_rvm_id_rvms_id_fk" FOREIGN KEY ("rvm_id") REFERENCES "public"."rvms"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "machine_status_details" ADD CONSTRAINT "machine_status_details_machine_status_id_machine_status_id_fk" FOREIGN KEY ("machine_status_id") REFERENCES "public"."machine_status"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rvms" ADD CONSTRAINT "rvms_location_id_locations_id_fk" FOREIGN KEY ("location_id") REFERENCES "public"."locations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rvms" ADD CONSTRAINT "rvms_producer_id_producers_id_fk" FOREIGN KEY ("producer_id") REFERENCES "public"."producers"("id") ON DELETE no action ON UPDATE no action;