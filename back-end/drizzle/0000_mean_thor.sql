CREATE TABLE "tomra_events" (
	"id" serial PRIMARY KEY NOT NULL,
	"received_on" timestamp DEFAULT now() NOT NULL,
	"processed_on" timestamp,
	"payload" text
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"full_name" text,
	"phone" varchar(256)
);
