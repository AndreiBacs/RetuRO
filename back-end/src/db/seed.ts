import { db } from "./db.ts";
import {
  producers,
  locations,
  rvms,
  machine_status,
  machine_status_details,
  connection_status,
  tomraEvents,
  barcodes,
} from "./schema.ts";
import { parse } from "csv-parse";

export async function seedDatabase() {
  console.log("🌱 Starting database seeding...");

  try {
    // Clear existing data (optional - comment out if you want to keep existing data)
    console.log("🧹 Clearing existing data...");
    await db.delete(machine_status_details);
    await db.delete(machine_status);
    await db.delete(connection_status);
    await db.delete(rvms);
    await db.delete(locations);
    await db.delete(producers);
    await db.delete(tomraEvents);
    await db.delete(barcodes);

    // Seed Producers
    console.log("🏭 Seeding producers...");
    const producerData = [
      {
        name: "TOMRA ROMANIA",
        address_line_1: "Str. Barbu Văcărescu 164a",
        address_line_2: "C3 , sc. B, et.3",
        city: "București",
        state: "B",
        zip: "020285",
        country: "RO",
        phone: "+47 66 79 91 00",
        email: "office.ro@tomra.com",
        website: "https://www.tomra.com/ro-ro",
      },
      {
        name: "RVM Systems România",
        address_line_1: "Bd. Iuliu Maniu nr. 7",
        address_line_2: "et.1, cam. 17",
        city: "București",
        state: "B",
        zip: "061072",
        country: "RO",
        phone: "+40 726 696 466",
        email: "officero@rvmsystems.com",
        website: "https://rvmsystems.ro/",
      },
      {
        name: "Envipco România",
        address_line_1: "DN7, FN, Parcul Industrial Sebeş",
        address_line_2: "Fabrica Europeană",
        city: "Sebeş",
        state: "AB",
        zip: "515800",
        country: "RO",
        phone: "+40 786 325 776",
        email: "contact@envipco.ro",
        website: "https://envipco.ro/",
      },
      {
        name: "ValuePack România",
        address_line_1: "Strada Anul 1907 nr.22",
        address_line_2: "Zona Industrială",
        city: "Ploiești",
        state: "PH",
        zip: "100332",
        country: "RO",
        phone: "+40 741 158 398",
        email: " it@ihopereal.com",
        website: "https://valuepack.ro/",
      },
      {
        name: "RomCooling",
        address_line_1: "Str. Daniel Danielopolu, Nr. 30-32",
        address_line_2: "ET.1, Sector 1",
        city: "București",
        state: "B",
        zip: "077190",
        country: "RO",
        phone: "+40 757 104 068",
        email: "contact@romcooling.ro",
        website: "https://www.romcooling.ro/",
      },
    ];

    const locationData = [
      {
        name: "Kaufland Oradea-Rogerius",
        customer_id: "000001",
        customer_name: "Kaufland Oradea-Rogerius",
        address_line_1: "Calea Borșului, nr. 6",
        address_line_2: "Calea Borșului, Oradea 410605",
        city: "Oradea",
        state: "BH",
        zip: "410605",
        country: "RO",
        latitude: "47.092198",
        longitude: "21.870482",
      },
      {
        name: "Lidl Oradea-Rogerius",
        customer_id: "000002",
        customer_name: "Lidl Oradea-Rogerius",
        address_line_1: "Șoseaua Borșului 6C",
        city: "Oradea",
        state: "BH",
        zip: "410605",
        country: "RO",
        latitude: "47.076188",
        longitude: "21.901745",
      },
    ];

    const insertedProducers = await db
      .insert(producers)
      .values(producerData)
      .returning();
    console.log(`✅ Inserted ${insertedProducers.length} producers`);

    const insertedLocations = await db
      .insert(locations)
      .values(locationData)
      .returning();
    console.log(`✅ Inserted ${insertedLocations.length} locations`);

    // Seed Barcodes from CSV file
    console.log("📊 Reading barcodes from CSV file...");
    let insertedBarcodes: any[] = [];
    
    try {
      const csvPath = "./assets/Coduri inregistrate in Registrul Ambalajelor_11.08.2025.csv";
      const csvContent = await Deno.readTextFile(csvPath);
      
      const barcodeData: { barcode: string; status: string }[] = [];
      let rowCount = 0;

      // Parse CSV content
      const parser = parse(csvContent, {
        columns: true, // Use first row as headers
        skip_empty_lines: true,
      });

      for await (const record of parser) {
        rowCount++;
        const barcode = record.Barcode || record.barcode || "";
        const status = record.Status || record.status || "";
        
        if (barcode && status) {
          barcodeData.push({ barcode, status });
        }
      }

      console.log(`📋 Found ${rowCount} rows in CSV file`);
      console.log(`📦 Processed ${barcodeData.length} valid barcode entries`);

      if (barcodeData.length > 0) {
        // Insert in batches to avoid memory issues
        const batchSize = 1000;
        let totalInserted = 0;
        
        for (let i = 0; i < barcodeData.length; i += batchSize) {
          const batch = barcodeData.slice(i, i + batchSize);
          const batchResult = await db
            .insert(barcodes)
            .values(batch)
            .returning();
          totalInserted += batchResult.length;
          console.log(`📦 Inserted batch ${Math.floor(i / batchSize) + 1}: ${batchResult.length} records`);
        }
        
        insertedBarcodes = Array(totalInserted).fill({}); // Create array for summary
        console.log(`✅ Inserted ${totalInserted} barcodes from CSV file`);
      } else {
        console.log("⚠️ No valid barcode data found in CSV file");
      }
    } catch (csvError) {
      console.error("❌ Error reading CSV file:", csvError);
      console.log(
        "💡 Make sure the CSV file exists at: ./assets/Coduri inregistrate in Registrul Ambalajelor_11.08.2025.csv"
      );
      console.log("📊 Using fallback sample data...");

      // Fallback to sample data if CSV reading fails
      const fallbackData = [
        { barcode: "5941234567890", status: "active" },
        { barcode: "5941234567891", status: "active" },
        { barcode: "5941234567892", status: "inactive" },
      ];

      insertedBarcodes = await db
        .insert(barcodes)
        .values(fallbackData)
        .returning();
      console.log(`✅ Inserted ${insertedBarcodes.length} fallback barcodes`);
    }

    console.log("🎉 Database seeding completed successfully!");
    console.log("\n📊 Summary:");
    console.log(`   - ${insertedProducers.length} producers`);
    console.log(`   - ${insertedLocations.length} locations`);
    console.log(`   - ${insertedBarcodes.length} barcodes`);
  } catch (error) {
    console.error("❌ Error seeding database:", error);
    throw error;
  }
}

// Run the seed function if this file is executed directly
if (import.meta.main) {
  await seedDatabase();
  Deno.exit(0);
}
