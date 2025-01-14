# RecipeList

### Screenshots

<img src="https://github.com/user-attachments/assets/5a68bb21-92e1-4deb-8daa-2a8b7ee35041" width="300">
<img src="https://github.com/user-attachments/assets/b302c498-6752-40fc-ba28-1504c511783b" width="300">

### Focus Areas
I felt that the main focus of the project was on the Image Caching; espeically without relying on third party solutions.
Being able to correctly manage the cache and bypass the built in caching mechanisms was the most technically interesting and challenging part of this project.

Second to that, was ensuring that the visuals were acceptable and the project made sense as a whole.

I also wanted to add something unique to the project, and opted to pull blurbs from Wikipedia about the recipes to be displayed.
Only proper versions of food items have corresponding Wikipedia entries.

### Time Spent
I spent most of a day working on this, ~5 hours. I wanted to ensure that the caching was done correctly and everything fit together logically.
I'm more familiar with UIKit, and translating that knowledge to SwiftUI took extra time and care.

### Trade-offs and Decisions
One major decision, was to independenty cache images in memory and on disk. This is more real world, as you typically have enough memory to keep things
loaded for a smoother scrolling experience. To fetch items from disk, you must relaunch the project or clear out the memory cache.

### Weakest Part of the Project:
As I mentioned above, I'm more familiar with UIKit and the weakest part of the project is surely my usage of SwiftUI. Everything is familiar, but different.

### Additional Information:
If you want to monitor the caching behavior, it's logging to console as it pulls from Network vs Disk vs Memory. The `...` menu has options to reset either cache.

![CacheControls](https://github.com/user-attachments/assets/19837281-8512-4bc9-a6be-d3c654c534c5)
