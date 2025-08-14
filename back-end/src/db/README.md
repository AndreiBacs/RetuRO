# Database Seeding

This directory contains the database schema and seeding functionality for the RetuRO backend.

## Files

- `schema.ts` - Database schema definitions using Drizzle ORM
- `db.ts` - Database connection and configuration
- `seed.ts` - Seed data for populating the database with test data

## Running the Seed

To populate your database with test data, run:

```bash
deno task db:seed
```

Or directly:

```bash
deno run --allow-net --allow-read --allow-env --env-file=env.dev src/db/seed.ts
```

## What the Seed Creates

The seed file creates realistic test data for:

### Producers (5 records)
- TOMRA ROMANIA (Romania)
- RVM Systems România (Romania)
- Envipco România (Romania)
- ValuePack România (Romania)
- RomCooling (Romania)

### Locations (2 records)
- Kaufland Oradea-Rogerius
- Lidl Oradea-Rogerius

### Barcodes (from Excel file)
- Reads from: `assets/Coduri inregistrate in Registrul Ambalajelor_11.08.2025.xlsx`
- Columns: barcode, status
- Automatically processes all valid entries

## Data Relationships

The seed data creates a realistic scenario with Romanian RVM producers:
- TOMRA ROMANIA - Global leader in RVM solutions
- RVM Systems România - Local RVM manufacturer with wide product range
- Envipco România - European factory producing RVMs locally
- ValuePack România - Romanian packaging and recycling solutions
- RomCooling - Romanian cooling and refrigeration solutions

## Excel File Processing

The seed automatically reads barcode data from the Excel file:
- **File**: `assets/Coduri inregistrate in Registrul Ambalajelor_11.08.2025.xlsx`
- **Expected columns**: `barcode` and `status`
- **Processing**: Automatically filters out empty rows and handles case variations
- **Error handling**: Graceful fallback if file is missing or corrupted

## Customization

You can modify the `seed.ts` file to:
- Add more Romanian producers
- Add locations and RVMs for these producers
- Add machine status and connection data
- Modify contact information and addresses

## Notes

- The seed will clear existing data before inserting new data
- All producers are based in Romania
- Contact information uses Romanian phone numbers (+40)
- Addresses follow Romanian postal code format
