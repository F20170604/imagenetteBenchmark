# imagenetteBenchmark

Creates a subset of 1000 training images by randomly choosing 100 images from each class of Imagenette with a seed value of 42.  
Loads the new dataset subset into tensors after resizing images to size mentioned.

| size                    |name                    |  time            |  std       |  iterations  |
|-------------|:------------:|------------------:|--------------:|---------------:|
|   160 x 160       | PIL Image Load operation | 50212789562.0 ns (50 s) | ±   2.98 %    |       5  |
|   320 x 320       | PIL Image Load operation | 131345557481.0.0 ns (131 s) | ±   7.21 %    |       5  |
|   160 x 160       | STBImage Image Load operation | 49629429859.0 ns (49.6 s) | ±   4.24 %    |       5  |
|   320 x 320       | STBImage Image Load operation | 126589557798.0 ns (126 s) | ±   13.58 %    |       5  |
