import { Context } from "oak";
import { barcodes } from "../db/schema.ts";
import { db } from "../db/db.ts";
import { eq, count } from "drizzle-orm";
import { ApiResponse } from "../types/index.ts";

export class BarcodeController {
  static async checkBarcode(ctx: Context) {
    try {
      const body = await ctx.request.body().value;
      const barcode = typeof body === "string" ? body : body?.barcode;

      if (!barcode || typeof barcode !== "string") {
        ctx.response.status = 400;
        ctx.response.body = {
          success: false,
          data: false,
          error: "Invalid barcode",
          message: "Barcode must be a string",
        } as ApiResponse<boolean>;
        return;
      }

      // Basic barcode validation
      if (barcode.length < 8 || barcode.length > 20) {
        ctx.response.status = 400;
        ctx.response.body = {
          success: false,
          data: false,
          error: "Invalid barcode format",
          message: "Barcode must be between 8 and 20 characters",
        } as ApiResponse<boolean>;
        return;
      }
      
      const barcodeData = await db
        .select({ exists: count() })
        .from(barcodes)
        .where(eq(barcodes.barcode, barcode));
      const valid = barcodeData[0]?.exists > 0;

      const response: ApiResponse<boolean> = {
        success: true,
        data: valid,
        message: "Barcode checked successfully",
      };

      ctx.response.body = response;
    } catch (error: unknown) {
      ctx.response.status = 500;
      ctx.response.body = {
        success: false,
        data: false,
        error: "Failed to check barcode",
        message: error instanceof Error ? error.message : "Unknown error",
      } as ApiResponse<boolean>;
    }
  }
}
