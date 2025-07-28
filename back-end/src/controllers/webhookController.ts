import { Context } from 'oak';
import { TomraModel } from '../types/tomra.ts';
import { SignatureVerification } from '../utils/signatureVerification.ts';

export class WebhookController {

  /**
   * Handle incoming Tomra webhook payloads
   * @param ctx - Oak context
   */
  static async handleTomraWebhook(ctx: Context) {
    try {
      // Read the X-Hook-Signature header
      const hookSignature = ctx.request.headers.get('X-Hook-Signature');
      
      // Get the raw body for signature verification
      const rawBody = await ctx.request.body({ type: 'text' }).value;
      
      // Parse the request body as TomraModel
      const payload: TomraModel = JSON.parse(rawBody);
      
      // Log the received payload and signature
      console.log('📦 Tomra Webhook Payload Received:');
      console.log('Timestamp:', new Date().toISOString());
      console.log('X-Hook-Signature:', hookSignature || 'Not provided');
      console.log('Payload:', JSON.stringify(payload, null, 2));
      
      // Verify signature if provided
      if (hookSignature) {
        const isValid = await SignatureVerification.verifySignature(rawBody, hookSignature);
        console.log('🔐 Signature Verification:', isValid ? '✅ Valid' : '❌ Invalid');
        
        if (!isValid) {
          console.log('⚠️  Warning: Invalid signature - payload may not be from Tomra');
        }
      } else {
        console.log('⚠️  Warning: No signature provided - cannot verify authenticity');
      }
      
      console.log('---');
      
      // Return success response
      ctx.response.status = 200;
      ctx.response.body = {
        success: true,
        message: 'Webhook payload received and logged successfully',
        signatureValid: hookSignature ? await SignatureVerification.verifySignature(rawBody, hookSignature) : null,
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      console.error('❌ Error processing Tomra webhook:', error);
      
      ctx.response.status = 400;
      ctx.response.body = {
        success: false,
        error: 'Invalid payload format',
        message: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }

  /**
   * Health check for webhook endpoint
   * @param ctx - Oak context
   */
  static async webhookHealth(ctx: Context) {
    ctx.response.status = 200;
    ctx.response.body = {
      status: 'ok',
      message: 'Tomra webhook endpoint is ready',
      timestamp: new Date().toISOString()
    };
  }
}
