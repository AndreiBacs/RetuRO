import { Router } from 'oak';
import { WebhookController } from '../controllers/webhookController.ts';

const router = new Router();

// Webhook routes
router.post('/webhooks/tomra', WebhookController.handleTomraWebhook);
router.get('/webhooks/tomra/health', WebhookController.webhookHealth);

export default router; 