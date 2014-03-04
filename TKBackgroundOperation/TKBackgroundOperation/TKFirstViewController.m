//
//  TKFirstViewController.m
//  TKBackgroundOperation
//
//  Created by apple on 3/4/14.
//  Copyright (c) 2014 goe. All rights reserved.
//

#import "TKFirstViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>
#import "CTAssetsPickerController.h"
#import "UIImage-Helpers.h"
#import "UIImage+Resize.h"
#import "UIImage+WebP.h"
#import "UIImage+UIImageExt.h"


#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

@interface TKFirstViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_size;
@property (weak, nonatomic) IBOutlet UILabel *label_count;
@property (weak, nonatomic) IBOutlet UIView *viewBg;


@property (strong, nonatomic)  NSMutableArray * arrayImages;

@end

@implementation TKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray * arrayImages = [[NSMutableArray alloc] init];
    self.arrayImages = arrayImages;
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)addImageClick:(id)sender {
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.navigationBar.barStyle = UIBarStyleBlack;
    picker.navigationBar.barTintColor  = [UIColor colorWithRed:48.0/255.0 green:167.0/255.0 blue:255.0/255.0 alpha:1.0];
    picker.navigationBar.translucent = YES;
    picker.navigationBar.tintColor  = [UIColor whiteColor];
    picker.navigationBarHidden = NO;
    
    picker.maximumNumberOfSelection = 100;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    // only allow video clips if they are at least 5s
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(ALAsset* asset, NSDictionary *bindings) {
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 1;
        } else {
            return YES;
        }
    }];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (IBAction)uploadImageCkick:(id)sender {
    
}
- (IBAction)clearImageClick:(id)sender {
    
    
    
    self.label_count.text = @"";
    self.label_size.text = @"";
    [self.arrayImages removeAllObjects];
    [self.viewBg.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            UIImageView* vim = obj;
            [vim removeFromSuperview];
        }
    }];
    
}
- (IBAction)stopuploadimageClick:(id)sender {
    
}



- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count > 0) {
        [self.arrayImages addObjectsFromArray:assets];
        // add image view
        
        __block  int count  = 0 ;
        
        [self.arrayImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *asset =  obj;
            if (asset) {
                UIImage * image  = [UIImage imageWithCGImage:asset.thumbnail];
                int row = idx/6;
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(44*(idx%6)+5*(idx%6+1), (44+5) * row, 44, 44)];
                iv.contentMode = UIViewContentModeScaleAspectFill;
                iv.clipsToBounds = YES;
                iv.tag = idx;
                [iv setImage:image];
                
                [self.viewBg addSubview:iv];
                
                
                
                ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                CGImageRef imgRef = [assetRep fullResolutionImage];
                UIImage *imagefull = [UIImage imageWithCGImage:imgRef
                                                     scale:assetRep.scale
                                               orientation:(UIImageOrientation)assetRep.orientation];
                
                int Wasy = imagefull.size.width/APP_SCREEN_WIDTH;
                int Hasy = imagefull.size.height/APP_SCREEN_HEIGHT;
                int quality = Wasy/2;
                UIImage * newimage = [[imagefull copy] resizedImage:CGSizeMake(APP_SCREEN_WIDTH*Wasy/quality, APP_SCREEN_HEIGHT*Hasy/quality) interpolationQuality:kCGInterpolationLow];
                
                
//                 enum CGInterpolationQuality {
//                 kCGInterpolationDefault = 0,	/* Let the context decide. */
//                kCGInterpolationNone = 1,	/* Never interpolate. */
//                kCGInterpolationLow = 2,	/* Low quality, fast interpolation. */
//                kCGInterpolationMedium = 4,	/* Medium quality, slower than
//                                             kCGInterpolationLow. */
//                kCGInterpolationHigh = 3	/* Highest quality, slower than
//                                             kCGInterpolationMedium. */
////            }
                NSData * FileData = UIImageJPEGRepresentation(newimage, 0.5);
//                 NSData *FileData  =  [UIImage imageToWebP:newimage quality:75.0];
                int length = FileData.length / 1000 ; //kb
                count +=length;
                
            }
        }];
        
        self.label_count.text = [NSString stringWithFormat:@"count : %d",self.arrayImages.count];
        self.label_size.text = [NSString stringWithFormat:@"size : %d KB ",count];
    }
}


#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)theInfo
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
