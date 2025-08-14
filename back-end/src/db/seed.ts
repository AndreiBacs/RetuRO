import { db } from './db.ts';
import { 
  producers, 
  locations, 
  rvms, 
  machine_status, 
  machine_status_details, 
  connection_status,
  tomraEvents 
} from './schema.ts';

export async function seedDatabase() {
  console.log('🌱 Starting database seeding...');

  try {
    // Clear existing data (optional - comment out if you want to keep existing data)
    console.log('🧹 Clearing existing data...');
    await db.delete(machine_status_details);
    await db.delete(machine_status);
    await db.delete(connection_status);
    await db.delete(rvms);
    await db.delete(locations);
    await db.delete(producers);
    await db.delete(tomraEvents);

    // Seed Producers
    console.log('🏭 Seeding producers...');
    const producerData = [
      {
        name: 'TOMRA ROMANIA',
        address_line_1: 'Str. Barbu Văcărescu 164a',
        address_line_2: 'C3 , sc. B, et.3',
        city: 'București',
        state: 'B',
        zip: '020285',
        country: 'RO',
        phone: '+47 66 79 91 00',
        email: 'office.ro@tomra.com',
        website: 'https://www.tomra.com/ro-ro',
      },
      {
        name: 'RVM Systems România',
        address_line_1: 'Bd. Iuliu Maniu nr. 7',
        address_line_2: 'et.1, cam. 17',
        city: 'București',
        state: 'B',
        zip: '061072',
        country: 'RO',
        phone: '+40 726 696 466',
        email: 'officero@rvmsystems.com',
        website: 'https://rvmsystems.ro/',
      },
      {
        name: 'Envipco România',
        address_line_1: 'DN7, FN, Parcul Industrial Sebeş',
        address_line_2: 'Fabrica Europeană',
        city: 'Sebeş',
        state: 'AB',
        zip: '515800',
        country: 'RO',
        phone: '+40 786 325 776',
        email: 'contact@envipco.ro',
        website: 'https://envipco.ro/',
      },
      {
        name: 'ValuePack România',
        address_line_1: 'Strada Anul 1907 nr.22',
        address_line_2: 'Zona Industrială',
        city: 'Ploiești',
        state: 'PH',
        zip: '100332',
        country: 'RO',
        phone: '+40 741 158 398',
        email: ' it@ihopereal.com',
        website: 'https://valuepack.ro/',
      },
      {
        name: 'RomCooling',
        address_line_1: 'Str. Daniel Danielopolu, Nr. 30-32',
        address_line_2: 'ET.1, Sector 1',
        city: 'București',
        state: 'B',
        zip: '077190',
        country: 'RO',
        phone: '+40 757 104 068',
        email: 'contact@romcooling.ro',
        website: 'https://www.romcooling.ro/',
      },
    ];

    const insertedProducers = await db.insert(producers).values(producerData).returning();
    console.log(`✅ Inserted ${insertedProducers.length} producers`);

    console.log('🎉 Database seeding completed successfully!');
    console.log('\n📊 Summary:');
    console.log(`   - ${insertedProducers.length} producers`);

  } catch (error) {
    console.error('❌ Error seeding database:', error);
    throw error;
  }
}

// Run the seed function if this file is executed directly
if (import.meta.main) {
  await seedDatabase();
  Deno.exit(0);
}
