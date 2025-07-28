import { Context } from 'oak';
import { TomraModel } from '../types/tomra.ts';

export class WebhookController {
  private static get WEBHOOK_SECRET(): string {
    const secret = Deno.env.get('TOMRA_WEBHOOK_SECRET');
    if (!secret) {
      throw new Error('TOMRA_WEBHOOK_SECRET environment variable is not set');
    }
    return secret;
  }

  /**
   * Verify HMAC-SHA256 signature
   * @param payload - The raw payload string
   * @param signature - The signature from X-Hook-Signature header
   * @returns boolean indicating if signature is valid
   */
  private static async verifySignature(payload: string, signature: string): Promise<boolean> {
    try {
      // Create HMAC-SHA256 using the secret
      const encoder = new TextEncoder();
      const keyData = encoder.encode(this.WEBHOOK_SECRET);
      const messageData = encoder.encode(payload);
      
      const cryptoKey = await crypto.subtle.importKey(
        'raw',
        keyData,
        { name: 'HMAC', hash: 'SHA-256' },
        false,
        ['sign']
      );
      
      const signedMessage = await crypto.subtle.sign('HMAC', cryptoKey, messageData);
      const expectedSignature = Array.from(new Uint8Array(signedMessage))
        .map(b => b.toString(16).padStart(2, '0'))
        .join('');
      
      // Remove 'sha256=' prefix if present
      const receivedSignature = signature.replace(/^sha256=/, '');
      
      return expectedSignature === receivedSignature;
    } catch (error) {
      console.error('❌ Error verifying signature:', error);
      return false;
    }
  }

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
        const isValid = await this.verifySignature(rawBody, hookSignature);
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
        signatureValid: hookSignature ? await this.verifySignature(rawBody, hookSignature) : null,
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
