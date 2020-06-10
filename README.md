# imagenetteBenchmark

Creates a subset of 1000 training images by randomly choosing 100 images from each class of Imagenette with a seed value of 42.  

*----*

1.) First we get the paths of images in the datasetType  
2.) Load the image using that library  
3.) Convert and resize it to appropriate tensor  
4.) Calculate its label  
5.) Append it to final list lof tensors and labels.  

Benchmark Results

| size                    |name                    |  time            |  std       |  iterations  |
|-------------|:------------:|:------------------:|:--------------:|:---------------:|
|   160 x 160       | PIL Image Load operation | 50212789562.0 ns (50 s) | ±   2.98 %    |       5  |
|   320 x 320       | PIL Image Load operation | 131345557481.0.0 ns (131 s) | ±   7.21 %    |       5  |
|   160 x 160       | STBImage Image Load operation | 49629429859.0 ns (49.6 s) | ±   4.24 %    |       5  |
|   320 x 320       | STBImage Image Load operation | 126589557798.0 ns (126 s) | ±   13.58 %    |       5  |

*----*


1.) First we get the paths of images in the datasetType  
2.) Load the image using that library  
3.) Convert and resize it to appropriate tensor  

New Benchmark Results

| size                    |name                    |  time            |  std       |  iterations  |
|-------------|:------------:|:------------------:|:--------------:|:---------------:|
|   160 x 160       | PIL Image Load operation | 1119275437.5 ns (1.1 s) | ±   10.5 %    |       200  |
|   320 x 320       | PIL Image Load operation | 3447590354.0 ns (3.4 s) | ±   7.97 %    |       25  |
|   160 x 160       | STBImage Image Load operation | 929056745.0 ns (0.9 s) | ±   0.74 %    |       5  |
|   320 x 320       | STBImage Image Load operation | 2794930989.0 ns (2.8 s) | ±   0.95 %    |       5  |
