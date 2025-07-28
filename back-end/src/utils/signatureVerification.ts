/**
 * Utility functions for signature verification
 */

export class SignatureVerification {
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
  static async verifySignature(payload: string, signature: string): Promise<boolean> {
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
} 