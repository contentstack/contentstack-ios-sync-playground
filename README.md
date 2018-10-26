# Build a playground app using Sync API with Contentstack’s iOS SDK

This is a demo playground app built using Contentstack’s iOS SDK and Sync API. You can try out and play with our Sync API with this example app, before building bigger and better applications.

Note that this app does not store data on the device’s local storage. To create offline apps, view our other [example app that uses Persistence Library](https://github.com/contentstack/contentstack-ios-persistence-example) with the Sync API.

Perform the steps given below to use this example app.

## Prerequisites
-  [Xcode 7.0 and later](https://developer.apple.com/xcode/)
- Mac OS X 10.10.4 and later
-  [Contentstack account](https://www.app.contentstack.com/)
- [Basic knowledge of Contentstack](https://www.contentstack.com/docs/)

In this tutorial, we will first go through the steps involved in configuring Contentstack and then look at the steps required to customize and use the presentation layer.

# Step 1: Create a stack

Log in to your Contentstack account, and [create a new stack](https://www.contentstack.com/docs/guide/stack#create-a-new-stack). Read more about [stacks](https://www.contentstack.com/docs/guide/stack).

## Step 2: Add a publishing environment

[Add a publishing environment](https://www.contentstack.com/docs/guide/environments#add-an-environment) to publish your content in Contentstack. Provide the necessary details as per your requirement. Read more about [environments](https://www.contentstack.com/docs/guide/environments).

## Step 3: Import content types
For this app, we need one content type: Session. Here’s what it is needed for:
- Session: Lets you add the session content to your app

For quick integration, we have already created the content type. [Download the content types](https://drive.google.com/open?id=1q6JlsAhFjYKnWmMllUrNY4NQMP0ZnEIW) and [import](https://www.contentstack.com/docs/guide/content-types#importing-a-content-type) it to your stack. (If needed, you can [create your own content types](https://www.contentstack.com/docs/guide/content-types#creating-a-content-type). Read more about [Content Types](https://www.contentstack.com/docs/guide/content-types).)

Now that all the content types are ready, let’s add some content for your Sync Playground app.
## Step 4: Adding content
[Create](https://www.contentstack.com/docs/guide/content-management#add-a-new-entry) and [publish](https://www.contentstack.com/docs/guide/content-management#publish-an-entry) entries for the ‘Session’ content type.

Now that we have created the sample data, it’s time to use and configure the presentation layer.

## Step 5: Clone and configure the application

To get your app up and running quickly, we have created a sample playground app. Clone the Github repo given below and change the configuration as per your need:
```
$ git clone https://github.com/contentstack/contentstack-ios-sync-playground.git
```
Now add your Contentstack API Key, Delivery Token, and Environment to the ```APIManager.swift``` file within your project. (Find your [Stack's API Key and Delivery Token](https://www.contentstack.com/docs/apis/content-delivery-api/#authentication)).

```
class StackConfig {

    static var APIKey = "***REMOVED***"
    static var AccessToken = "DELIVERY_TOKEN"
    static var EnvironmentName = "ENVIRONMENT"
    static var _config : Config {
        get {
            let config = Config()
            config.host = "URL"
            return config
        }
    }
}
```

This will initiate your project.

## Step 6: Initialize sync

To perform initial ```sync```, use the sync method, which fetches all the content of the specified environment.

```
APIManager.stack.sync {[weak self] (stack, error) in
guard let slf = self, let syncStack = stack else {return}
if (error == nill) {
syncStack.items.count;
}
}
```

On successful sync completion, you will get a sync token in response, which you need to use to get subsequent (delta) syncs.

<img src='https://github.com/contentstack/contentstack-ios-sync-playground/blob/master/Images/InitialSyncProgress.png' width='300' height='550'/>


## Step 7: Use pagination token

If the result of the initial sync contains more than 100 records, the response would be paginated. In that case, it returns a pagination token. While the SDK continues to automatically fetch the next batch of data using the pagination token, it comes in handy in case the sync process is interrupted midway (due to network issues, etc.). You can use it to reinitiate sync from where it was interrupted.
```
APIManger.stack.syncPaginationToken(<pagination_token>, completion: {[weak self] (stack, error) in
    guard let slf = self, let syncStack = stack else {return}
    if (error == nill) {
        syncStack.items.count;
    }
})
```
## Step 8: Publish new entries

In order to understand how you can also fetch only new (incremental) updates that were done since the last sync, you should create more entries and publish them. You can then use the Subsequent Sync call given below to see how it works.

## Step 9: Perform subsequent sync

In the response of the initial sync, you get a sync token in the response. This token is used to fetch incremental updates, i.e., only the changes made after the initial sync. Use the syncToken method to perform subsequent syncs.


```
APIManager.stack.syncToken(<sync_token>, completion: { (syncStack:SyncStack, error:NSError) in
    guard let slf = self, let syncStack = stack else {return}
    if (error == nill) {
        syncStack.items.count;
    }
]
})
```
<img src='https://github.com/contentstack/contentstack-ios-sync-playground/blob/master/Images/Subsequentsync.png' width='300' height='550'/>

This is a simple playground app that helps you understand how the Sync API works with the iOS SDK. To learn how to persist data in order to create offline apps, refer to the [iOS demo app](https://github.com/contentstack/contentstack-ios-persistence-example) built using the Persistence Library.

## More Resources
-   [Getting started with iOS SDK](https://www.contentstack.com/docs/platforms/ios)
-   [Using the Sync API with iOS SDK](https://www.contentstack.com/docs/guide/synchronization/using-the-sync-api-with-ios-sdk)
-   [Using Persistence Library with iOS SDK](https://www.contentstack.com/docs/guide/synchronization/using-realm-persistence-library-with-ios-sync-sdk)
-   [Sync API documentation](https://www.google.com/url?q=https://www.contentstack.com/docs/apis/content-delivery-api/#synchronization&sa=D&ust=1540373553842000&usg=AFQjCNErftWljzbGy77oAYK01xsOU4z_rw)
