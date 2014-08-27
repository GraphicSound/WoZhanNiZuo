//
//  YHLoadHeaderImage.m
//  我占你坐
//
//  Created by yu_hao on 6/2/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "YHLoadHeaderImage.h"

@implementation YHLoadHeaderImage

+ (void)retriveImageForScrollView:(UIScrollView *)scrollView {
    NSLog(@"----retriveImageForScrollView");
    
    NSString *retrieveImageString = [NSString stringWithFormat:@"%@/library-header-image/image-string", serverUrl];
    NSURL *retrieveImageStringUrl = [NSURL URLWithString:[retrieveImageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableString *imageString = [NSMutableString stringWithContentsOfURL:retrieveImageStringUrl encoding:NSUTF8StringEncoding error:nil];
    NSArray *imageStringArray = [[NSArray alloc] init];
    
    if (imageString != nil) {
        imageStringArray = [imageString componentsSeparatedByString:@";"];
        
        for (int i = 0; i < imageStringArray.count; i++) {
            NSString *imageNumberString = [NSString stringWithFormat:@"%d", i];
            NSString *imageNameString = imageStringArray[i];
            
            // 查询本地是否已经有照片
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = [searchPaths objectAtIndex:0]; // 都是用这种方法找到document文件夹
            
            NSString *saveImageDataPath = [NSString new];
            // saveImageDataPath = [NSString stringWithFormat:@"%@/library-header-image/%@.png", documentPath, imageNameString];
            saveImageDataPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageNameString]]; // 以后记住尽量用这种方式，不要用上面那种
            
            if ([fileManager fileExistsAtPath: saveImageDataPath] == YES)
            {
                NSLog(@"!!!照片已经存在本地");
                
                // 添加imageView
                UIImage *image = [UIImage imageWithContentsOfFile:saveImageDataPath];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * imageNumberString.intValue, 0, 320, 160)];
                imageView.image = image;
                [scrollView addSubview:imageView];
            } else {
                dispatch_async(kBgQueue, ^{
                    NSString *retrieveUpdateString = [NSString stringWithFormat:@"%@/library-header-image/%@.png", serverUrl, imageStringArray[i]];
                    NSURL *retrieveUpdateUrl = [NSURL URLWithString:[retrieveUpdateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSError* error = nil;
                    NSData* data = [NSData dataWithContentsOfURL:retrieveUpdateUrl
                                                         options:NSDataReadingUncached
                                                           error:&error]; // 居然能如此简单！！！
                    if (error) {
                        NSLog(@"retrieveUpdateFromServer error");
                    } else
                    {
                        [self performSelectorOnMainThread:@selector(parseImageData:)
                                               withObject:@[data, scrollView, imageNumberString, imageNameString]
                                            waitUntilDone:YES];
                        NSLog(@"拉取数据成功，大小共为%fKB", data.length/1024.0);
                    }
                });
            }
        }
    }
    NSLog(@"%d----retriveImageForScrollView", imageStringArray.count);
}

+ (void)parseImageData:(NSArray *)dataArray {
    NSData *imageData = dataArray[0];
    UIScrollView *scrollView = dataArray[1];
    NSString *imageNumberString = dataArray[2];
    NSString *imageNameString = dataArray[3];
    
    // 添加imageView
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * imageNumberString.intValue, 0, 320, 160)];
    imageView.image = image;
    [scrollView addSubview:imageView];
    
    // 写到本地
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0]; // 都是用这种方法找到document文件夹
    
    NSString *saveImageDataPath = [NSString new];
    // saveImageDataPath = [NSString stringWithFormat:@"%@/library-header-image/%@.png", documentPath, imageNameString];
    saveImageDataPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageNameString]]; // 以后记住尽量用这种方式，不要用上面那种
    NSLog(@"saveImageDataPath:%@", saveImageDataPath);
    [imageData writeToFile:saveImageDataPath atomically:YES]; // 写文件，写的是nsdata
}

@end
