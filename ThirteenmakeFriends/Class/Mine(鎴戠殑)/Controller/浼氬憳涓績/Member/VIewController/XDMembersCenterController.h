//
//  XDMembersCenterController.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 2017/7/11.
//  Copyright © 2017年 ThirtyOneDay. All rights reserved.
//

#import "BaseViewController.h"
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, buyMembersTag)
{
    //以下是枚举成员
    IAP0pMonth=40,
    IAP0pPpermanent=448,
    IAP0pGaoduan=1998,
    IAP1pZhizun=4998
    
};

@interface XDMembersCenterController : BaseViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    int buyType;
}


-(void)RequestProductData;


-(void)buy:(int)type;


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;


- (void) completeTransaction: (SKPaymentTransaction *)transaction;


- (void) failedTransaction: (SKPaymentTransaction *)transaction;


-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;


-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;



- (void) restoreTransaction: (SKPaymentTransaction *)transaction;


-(void)provideContent:(NSString *)product;


-(void)recordTransaction:(NSString *)product;

@end
