$code = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class ImageProcessor {
    public static void RemoveWhiteBackground(string inputPath, string outputPath) {
        using (Bitmap bmp = new Bitmap(inputPath)) {
            Bitmap result = new Bitmap(bmp.Width, bmp.Height, PixelFormat.Format32bppArgb);
            
            for (int y = 0; y < bmp.Height; y++) {
                for (int x = 0; x < bmp.Width; x++) {
                    Color c = bmp.GetPixel(x, y);
                    int sum = c.R + c.G + c.B;
                    
                    // White or very near-white becomes perfectly transparent
                    if (sum >= 720) {
                        result.SetPixel(x, y, Color.Transparent);
                    } 
                    // Edges/antialiasing fading out
                    else if (sum > 600) {
                        float factor = (720f - sum) / 120f; 
                        int alpha = (int)(255 * Math.Max(0, Math.Min(1, factor)));
                        
                        // Darken the remaining color so it doesn't look like a white halo on black bg
                        int r = (int)(c.R * factor);
                        int g = (int)(c.G * factor);
                        int b = (int)(c.B * factor);
                        
                        result.SetPixel(x, y, Color.FromArgb(alpha, r, g, b));
                    } 
                    // Normal pixels
                    else {
                        result.SetPixel(x, y, c);
                    }
                }
            }
            result.Save(outputPath, ImageFormat.Png);
        }
    }
}
"@
Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing
[ImageProcessor]::RemoveWhiteBackground("C:\Users\diazg\.gemini\antigravity\scratch\quintas-gym\images\logo_backup.png", "C:\Users\diazg\.gemini\antigravity\scratch\quintas-gym\images\logo.png")
Write-Host "Logo successfully processed to remove white background."
