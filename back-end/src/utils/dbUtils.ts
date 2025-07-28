import db from '../config/db.ts';

export interface PaginationOptions {
  page: number;
  limit: number;
}

export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
}

// Generic pagination helper
export async function paginateQuery<T>(
  query: string,
  params: any[] = [],
  options: PaginationOptions
): Promise<PaginatedResult<T>> {
  const { page, limit } = options;
  const offset = (page - 1) * limit;

  // Get total count
  const countQuery = query.replace(/SELECT .* FROM/, 'SELECT COUNT(*) as total FROM');
  const countResult = await db.query(countQuery as any);
  const total = parseInt((countResult as any[])[0]?.total || '0');

  // Get paginated data
  const paginatedQuery = `${query} LIMIT ${limit} OFFSET ${offset}`;
  const data = await db.query(paginatedQuery as any);

  const totalPages = Math.ceil(total / limit);

  return {
    data: data as T[],
    pagination: {
      page,
      limit,
      total,
      totalPages,
      hasNext: page < totalPages,
      hasPrev: page > 1,
    },
  };
}

// Safe database query execution with error handling
export async function safeQuery<T>(
  query: string
): Promise<T[]> {
  try {
    const result = await db.query(query as any);
    return result as T[];
  } catch (error) {
    console.error('Database query error:', error);
    throw new Error(`Database query failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

// Database connection health check
export async function isDatabaseConnected(): Promise<boolean> {
  try {
    await db.query("SELECT 1" as any);
    return true;
  } catch {
    return false;
  }
}

// Generate database backup (for development)
export async function createBackup(): Promise<string> {
  try {
    const tables = ['users', 'tomra_triggers', 'migrations'];
    const backup: any = {};
    
    for (const table of tables) {
      const data = await db.query(`SELECT * FROM ${table}` as any);
      backup[table] = data;
    }
    
    return JSON.stringify(backup, null, 2);
  } catch (error) {
    console.error('Backup creation failed:', error);
    throw error;
  }
} 