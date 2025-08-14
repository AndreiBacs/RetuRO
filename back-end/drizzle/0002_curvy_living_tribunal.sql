CREATE TABLE "barcodes" (
	"id" serial PRIMARY KEY NOT NULL,
	"barcode" varchar(256) NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
