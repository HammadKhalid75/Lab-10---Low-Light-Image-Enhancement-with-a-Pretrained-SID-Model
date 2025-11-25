# Low-Light Image Enhancement  
**"Learning to See in the Dark" pretrained network – MATLAB demo**

### Assignment goal
Use MathWorks’ pretrained Sony low-light enhancement network on a real extremely dark photo **without** training or downloading the huge SID dataset.

### My submission
- Real-world input: a nearly black night photo of a United Rentals porta-potty (Example_03.png)
- The network successfully recovers readable text, logos, and details that were completely invisible in the original image.

### Key improvements I made
1. **Real dark image** – no artificial darkening needed (original is already almost pure black)
2. Added only minimal realistic sensor noise instead of heavy darkening
3. Fixed the `imadjust` error on RGB images  
   Replaced with proper RGB-compatible post-processing:
   ```matlab
   out = imlocalbrighten(out);
   out = imsharpen(out, 'Radius', 1.5, 'Amount', 1.2);
   out = histeq(out);
   ```
4. Clear before/after comparison (4-panel figure)

### Files in this repository
- `lowLightEnhance.m` – complete, error-free script (ready to run)
- `Example_03.png` – original extremely dark input image
- `enhanced_result.png` – final bright, sharp, and colorful output
- `README.md` – this file

### How to run
1. Put all files in the same folder
2. Run `lowLightEnhance.m` in MATLAB  
   (First run downloads the ~60 MB pretrained model automatically)
3. Enjoy the dramatic enhancement!

### Results
| Original (almost black) | Input to network | Raw network output | Final enhanced result |
|-------------------------|------------------|--------------------|-----------------------|
| ![](Example_03.png)     | ![](light.png)    | ![](rawn.png)  | ![](enhanced_result.png) |

