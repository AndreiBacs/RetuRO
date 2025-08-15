import { Router } from "oak";
import { BarcodeController } from "../controllers/barcodeController.ts";

const router = new Router();

router.post("/barcodes/check", BarcodeController.checkBarcode);

export default router;
