//
//  NSArrayCategoriesTests.m
//  SampleProject
//
//  Created by Marin Usalj on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveSugar.h"
#import "Kiwi.h"

SPEC_BEGIN(ArrayAdditions)

describe(@"NSArray categories", ^{
    
    NSArray *sampleArray = [NSArray arrayWithObjects:@"first", @"second", @"third", nil];
    NSArray *oneToTen = @[ @1, @2, @3, @4, @5, @6, @7, @8, @9, @10 ];
    
    it(@"aliases -first to -objectAtIndex:0", ^{
        [[sampleArray.first should] equal:[sampleArray objectAtIndex:0]];
    });
    
    it(@"-first does not crash if there's no objects in array", ^{
        KWBlock *block = [[KWBlock alloc] initWithBlock:^{
            [@[].first description];
        }];
        [[block shouldNot] raise];
    });
    
    it(@"aliases -last to -lastObject", ^{
        [[sampleArray.last should] equal:[sampleArray lastObject]];        
    });
    
   
    context(@"Iterating using block", ^{
       
        it(@"iterates using -each:^", ^{
            NSMutableArray *duplicate = [sampleArray mutableCopy];
            
            [sampleArray each:^(id object) {
                [[duplicate should] contain:object];
                [duplicate removeObject:object];
            }];
            [[duplicate should] beEmpty];
        });
        
        it(@"iterates using -eachWithIndex:^", ^{
            NSMutableArray *duplicate = [sampleArray mutableCopy];
            
            [sampleArray eachWithIndex:^(id object, int index) {
                [[object should] equal:[sampleArray objectAtIndex:index]];
                [duplicate removeObject:object];
            }];
            [[duplicate should] beEmpty];
        });
        
    });
    
    it(@"aliases -containsObject to -includes", ^{
        [[@([sampleArray includes:@"second"]) should] equal:@(YES)];
    });
    
    it(@"-map returns an array of objects returned by the block", ^{
        [[[sampleArray map:^id(id object) {
            return [NSNumber numberWithBool:[object isEqualToString:@"second"]];
        }] should] equal:@[ @(NO), @(YES), @(NO) ]];
    });
    
    it(@"-select returns an array containing all the elements of NSArray for which block is not false", ^{
        [[[oneToTen select:^BOOL(id object) {
            return [object intValue] % 3 == 0;
        }] should] equal:@[ @3, @6, @9 ]];
    });

    it(@"-detect returns the first element in NSArray for which block is true", ^{
        [[[oneToTen detect:^BOOL(id object) {
            return [object intValue] % 3 == 0;
        }] should] equal:@3];
    });
    
    it(@"-detect is safe", ^{
       [[[oneToTen detect:^BOOL(id object) {
           return [object intValue] == 1232132143;
       }] should] beNil];
    });
    
    it(@"-reject returns an array containing all the elements of NSArray for which block is false", ^{
        [[[oneToTen reject:^BOOL(id object) {
            return [object intValue] % 3 == 0;
        }] should] equal:@[ @1, @2, @4, @5, @7, @8, @10 ]];
    });
    
    it(@"-flatten returns a one-dimensional array that is a recursive flattening of the array", ^{
        NSArray *multiDimensionalArray = @[ @[ @1, @2, @3 ], @[ @4, @5, @6, @[ @7, @8 ] ], @9, @10 ];
        [[[multiDimensionalArray flatten] should] equal:oneToTen];
    });
    
    context(@"array subsets", ^{
    
        it(@"creates subset of array", ^{
            [[[sampleArray take:2] should] equal:@[ @"first", @"second" ]];
        });
        
        
        it(@"creates subset of array and shouldn't raise exeption", ^{
            [[[sampleArray take:[sampleArray count]+1] should] equal:sampleArray];
        });
        
        it(@"creates subset of array using block", ^{
            [[[sampleArray takeWhile:^BOOL(id object) {
                
                return ![object isEqualToString:@"third"];
                
            }] should] equal:@[ @"first", @"second" ]];
        });
        
    });
    
    context(@"array range subscripting", ^{
        
        it(@"returns an array containing the elements at the specified range when passing an NSValue containing an NSRange", ^{
            NSValue *range = [NSValue valueWithRange: NSMakeRange(2, 5)];
            [[oneToTen[range] should] equal:@[@3, @4, @5, @6, @7]];
        });
        
        it(@"returns an array containing the elements at the specified range when passing a string that contains a parsable range", ^{
            [[oneToTen[@"2..5"] should] equal:@[@3, @4, @5, @6, @7]];
        });
        
        it(@"returns an empty array when passing an invalid or empty range", ^{
            [[oneToTen[@"notarange"] should] equal:@[]];
        });
        
        it(@"throws an invalid argument exception when passing anything other than an NSString or NSValue", ^{
            [[theBlock(^{
                [oneToTen[[[NSSet alloc] initWithArray:@[@1, @2]]] description];
            }) should] raiseWithName:NSInvalidArgumentException reason:@"expected NSString or NSValue argument, got __NSSetI instead"];
        });
        
        it(@"shouldn't break existing indexed subscripting", ^{
            [[oneToTen[1] should] equal:@2];
        });
    });
    
    context(@"join elements", ^{
        
        it(@"join the array with elements ", ^{
            [[[oneToTen join] should] equal:@"12345678910"];
        });
        
        it(@"join the array with elements separated by a dash", ^{
            [[[sampleArray join:@"-"] should] equal:@"first-second-third"];
        });
        
    });
    
    context(@"reverse elements", ^{
        it(@"reverses the elements in the array", ^{
            [[[oneToTen reverse] should] equal:@[@10, @9, @8, @7, @6, @5, @4, @3, @2, @1]];
        });
    });
    
    context(@"sorting", ^{
       
        it(@"-sort aliases -sortUsingComparator:", ^{
            [[[@[ @4, @1, @3, @2 ] sort] should] equal:@[ @1, @2, @3, @4 ]];
        });
        
    });
    
    context(@"zipping", ^{
        it(@"zips elements from two arrays of same size into one array", ^{
            [[[oneToTen zip:[oneToTen reverse] with:^id(id left, id right) {
                return @[left, right];
            }] should] equal:@[ @[@1, @10], @[@2, @9], @[@3, @8], @[@4, @7], @[@5, @6], @[@6, @5], @[@7, @4], @[@8, @3], @[@9, @2], @[@10, @1] ]];
            
        });
        
        it(@"zips elements from two arrays of different size into one array with size of shortest array", ^{
            [[[oneToTen zip:@[@"A", @"B", @"C"] with:^id(id left, id right) {
                return @[left, right];
            }] should] equal:@[ @[@1, @"A"], @[@2, @"B"], @[@3, @"C"] ]];
            
        });
        
        it(@"zips elements from two arrays of different size into one array with size of shortest array when shortest if on the left", ^{
            [[[@[@"A", @"B", @"C"] zip:oneToTen with:^id(id left, id right) {
                return @[left, right];
            }] should] equal:@[ @[@"A", @1], @[@"B", @2], @[@"C", @3] ]];
        });
    });
});


describe(@"Set operations", ^{
    
    NSArray *a = @[ @1, @2 ];
    NSArray *b = @[ @2, @3 ];
    
    it(@"return the elements common to both arrays ", ^{
        [[[a intersectionWithArray:b] should] equal:@[ @2 ]];
    });
    
    it(@"combine the two arrays, removing duplicate elements", ^{
        [[[a unionWithArray:b] should] equal:@[ @1, @2, @3 ]];
    });
    
    it(@"return the elements in a that are not in b", ^{
        [[[a relativeComplement:b] should] equal:@[ @1 ]];
    });
    
    it(@"return the elements in b that are not in a", ^{
        [[[b relativeComplement:a] should] equal:@[ @3 ]];
    });
    
    it(@"return the elements unique to both arrays", ^{
        [[[a symmetricDifference:b] should] equal:@[ @1, @3 ]];
    });
});


SPEC_END


