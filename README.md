# imagenetteBenchmark

Creates a subset of 1000 images by randomly choosing 100 images from each class of Imagenette with a seed value of 42.  
Loads the new dataset subset into tensors after resizing images to size [160, 160]

| size                    |name                    |  time            |  std       |  iterations  |
|-------------|:------------:|------------------:|--------------:|---------------:|
|   160 x 160       | PIL Image Load operation | 50212789562.0 ns (50 s) | ±   2.98 %    |       5  |
|   320 x 320       | PIL Image Load operation | 131345557481.0.0 ns (131 s) | ±   7.21 %    |       5  |. 
