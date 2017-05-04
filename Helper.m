//
//  Helper.m
//  Tapcraft
//
//  Created by Philips - sanny on 1/2/13.
//
//

#import "Helper.h"
@interface Helper ()
@end
@implementation Helper

-(id) init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
    
}

-(void) saveDataToFile:(NSString*) filePath forTitle:(NSString*)title what:(NSString*) this
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:this forKey:@"ADS"];
    [defaults synchronize];
}


-(NSString*) getStringFromFile:(NSString*)filePath What:(NSString*) this
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *ADS = [defaults objectForKey:@"ADS"];
    return ADS;
}

-(BOOL) copyThisFileToRoot:(NSString*) fileName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        
    {
        
        NSDictionary *temp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
        
        
        NSDictionary *glossary = [NSDictionary dictionaryWithDictionary:temp];
        if ([glossary writeToFile: path atomically: YES] == NO)
        {
            
            NSLog(@"Archiving Failed!");
            return NO;
            
        }
        
    } else
    {
        NSLog(@"File(s) Are Exist.");
        return YES;
        
    }
    
    NSLog(@"File Create successfully.");
    return YES;
    
}


-(BOOL) makeFileWithName:(NSString*)Filename andWriteToIt:(NSDictionary*) dic
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:Filename];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        
    {
        NSDictionary *glossary = [NSDictionary dictionaryWithDictionary:dic];
        if ([glossary writeToFile: path atomically: YES] == NO)
        {
            
            NSLog(@"Archiving Failed!");
            return NO;
            
        }
        
    } else
    {
        NSLog(@"File(s) Are Exist.");
        
        return YES;
    }
    
    
    NSLog(@"File Create successfully.");
    
    return YES;
}




-(NSDictionary*) settings
{
    NSDictionary *glossary = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"ON" ,@"sounds",
                              @"0" , @"score",
                              @"0" , @"FR",
                              
                              
                              
                              
                              nil];
    
    return glossary;
    
}

+(BOOL)isBought{
    //return YES;
    NSLog(@"iAd banner Loaded Successfully!");
    Helper *hlp = [[Helper alloc] init];
    NSString * a = [hlp getStringFromFile:@"settings.plist" What:@"ADS"];
    if (a==nil){
        return NO;
    }else{
        return YES;
    }
    
}



@end
