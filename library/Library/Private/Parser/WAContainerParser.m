/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "WAContainerParser.h"
#import "WABlobContainer.h"
#import "WAXMLHelper.h"

@implementation WAContainerParser

+ (NSString *)retrieveMarker:(xmlDocPtr)doc
{
    if (doc == nil) { 
		return nil; 
	}
    
    __block NSMutableString *marker = nil; 
    [WAXMLHelper performXPath:@"/EnumerationResults/NextMarker" 
                   onDocument:doc 
                        block:^(xmlNodePtr node)
     {
         xmlChar *value = xmlNodeGetContent(node);
         NSString *str = [[NSString alloc] initWithUTF8String:(const char*)value];
         xmlFree(value);
         int length = [str length];
         if (str != nil && length != 0) {
             marker = [NSMutableString stringWithString:str];
         }
         [str release];
     }];
    
     return marker;
}

+ (NSArray *)loadContainers:(xmlDocPtr)doc {
    
    if (doc == nil) 
    { 
		return nil; 
	}
	
    NSMutableArray *containers = [NSMutableArray arrayWithCapacity:30];
    
    [WAXMLHelper performXPath:@"/EnumerationResults/Containers/Container" 
                 onDocument:doc 
                      block:^(xmlNodePtr node)
     {
         NSString *name = [WAXMLHelper getElementValue:node name:@"Name"];
         NSString *url = [WAXMLHelper getElementValue:node name:@"Url"];
         NSString *metadata = [WAXMLHelper getElementValue:node name:@"Metadata"];

         WABlobContainer *container = [[WABlobContainer alloc] initContainerWithName:name URL:url metadata:metadata];
         [containers addObject:container];
         [container release];
     }];
    
    return [[containers copy] autorelease];
}

+ (NSArray *)loadContainersForProxy:(xmlDocPtr)doc {
    
    if (doc == nil) 
    { 
		return nil; 
	}
	
    NSString* containerURI = [WAXMLHelper getElementValue:(xmlNodePtr)doc name:@"anyURI"];
    NSMutableArray* containerNameUri = [[NSMutableArray alloc] initWithArray:[containerURI componentsSeparatedByString:@"?"]];
    NSString* tempURL = [containerNameUri objectAtIndex:0];
    NSString* blobProxyUrl = [containerNameUri objectAtIndex:1];
    NSMutableArray* containerNameUri2 = [[NSMutableArray alloc] initWithArray:[tempURL componentsSeparatedByString:@"/"]];
    NSString* containerName = [containerNameUri2 objectAtIndex:3];
    WABlobContainer *container = [[WABlobContainer alloc] initContainerWithName:containerName URL:tempURL metadata:blobProxyUrl];
    NSArray* containers = [NSArray arrayWithObject:container];
    
    [containerNameUri release];
    [containerNameUri2 release];
    [container release];
    
    return containers;
}

@end
