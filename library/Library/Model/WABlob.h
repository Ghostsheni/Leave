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

#import <Foundation/Foundation.h>

@class WABlobContainer;

/*! Blob is a class used to represent blobs within Windows Azure blob storage.*/
@interface WABlob : NSObject

/*! Name of the blob object */
@property (readonly) NSString* name;
/*! URL of the blob object */
@property (readonly) NSURL* URL;
/*! Container that the blob object belongs to */
@property (readonly) WABlobContainer* container;

/*! Returns an WABlob object initialized with a name and the url of the blob.*/
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL;

/*! Returns an WABlob object initialized with a name, the url of the blob and the parent contaner for the blob.*/
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL container:(WABlobContainer*)container;

@end
