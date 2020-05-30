# imagenetteBenchmark

Creates a subset of 1000 images by randomly choosing 100 images from each class of Imagenette with a seed value of 42.  
Loads the new dataset subset into tensors after resizing images to size [160, 160]

| name                    |  time            |  std       |  iterations  |
|-------------------------|:------------------:|--------------:|---------------:|
| PIL Image Load operation | 50212789562.0 ns | ±   2.98 %    |       5  |
