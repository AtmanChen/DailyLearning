 # Type of Queues: 
 ---
 ### There are 3 type of queues.
 
 ## 1. Main Queue
 This Queue has the highest priority of all, All UI updates should be done on this thread or otherwise lagging and weired crashed will occur in your application.
 ```
Dispatch.main.async {
    // update UI here...
}
 ```
 ## 2. Global Queue
 This Queue is separated into 4 main types and a default type according to QOS(Quality Of Service), from highest priority to lowest.
 ## 3. Custom Queue
